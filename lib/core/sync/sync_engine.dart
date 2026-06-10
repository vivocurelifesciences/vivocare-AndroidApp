import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vivocure/core/connectivity/connectivity_service.dart';
import 'package:vivocure/core/db/app_database.dart';
import 'package:vivocure/core/media/media_cache_service.dart';
import 'package:vivocure/core/network/api_client.dart';
import 'package:vivocure/core/sync/outbox_service.dart';
import 'package:vivocure/core/sync/pull_service.dart';
import 'package:vivocure/core/sync/push_service.dart';

enum SyncPhase { idle, pushing, pulling, media, error }

/// Observable sync status for UI (banner, pending-count chip, sync button).
class SyncState extends ChangeNotifier {
  SyncPhase _phase = SyncPhase.idle;
  String? _lastError;
  DateTime? _lastSyncAt;
  int _pendingOps = 0;
  bool _bootstrapDone = false;

  SyncPhase get phase => _phase;
  bool get isSyncing => _phase == SyncPhase.pushing ||
      _phase == SyncPhase.pulling ||
      _phase == SyncPhase.media;
  String? get lastError => _lastError;
  DateTime? get lastSyncAt => _lastSyncAt;
  int get pendingOps => _pendingOps;
  bool get bootstrapDone => _bootstrapDone;

  void _update({SyncPhase? phase, String? error, DateTime? syncedAt}) {
    if (phase != null) _phase = phase;
    _lastError = error;
    if (syncedAt != null) _lastSyncAt = syncedAt;
    notifyListeners();
  }

  void _setPending(int count) {
    if (_pendingOps == count) return;
    _pendingOps = count;
    notifyListeners();
  }

  void _setBootstrapDone(bool done) {
    _bootstrapDone = done;
    notifyListeners();
  }
}

/// Orchestrates push → pull → media, single-flight, with retry/backoff and
/// automatic triggers (connectivity regained, post-mutation debounce).
class SyncEngine {
  SyncEngine({
    required AppDatabase db,
    required ApiClient api,
    required ConnectivityService connectivity,
  })  : _db = db,
        _connectivity = connectivity,
        _outbox = OutboxService(db),
        state = SyncState() {
    _pull = PullService(db, api);
    _push = PushService(db, api, _outbox);
    _media = MediaCacheService(db);

    _pendingSub = _outbox.watchPendingCount().listen(state._setPending);
    _onlineSub = _connectivity.onlineAgain.listen((_) {
      debugPrint('[SYNC] Connectivity regained → sync');
      unawaited(syncNow(reason: 'connectivity'));
    });
    _restoreMeta();
  }

  final AppDatabase _db;
  final ConnectivityService _connectivity;
  final OutboxService _outbox;
  late final PullService _pull;
  late final PushService _push;
  late final MediaCacheService _media;
  final SyncState state;

  OutboxService get outbox => _outbox;

  Future<void>? _running;
  Timer? _mutationDebounce;
  int _consecutiveFailures = 0;
  Timer? _backoffTimer;
  StreamSubscription<int>? _pendingSub;
  StreamSubscription<void>? _onlineSub;

  Future<void> _restoreMeta() async {
    state._setBootstrapDone(await _db.getKv('bootstrap_done') == '1');
    final String? last = await _db.getKv('last_sync_at');
    if (last != null) {
      state._update(syncedAt: DateTime.tryParse(last));
    }
  }

  /// Full first sync after login. Resumable: cursors advance per page, so a
  /// killed app continues where it left off when this is called again.
  Future<void> bootstrap() async {
    await syncNow(reason: 'bootstrap');
    if (state.lastError == null) {
      await _db.setKv('bootstrap_done', '1');
      state._setBootstrapDone(true);
    }
  }

  /// Debounced trigger after local writes — batches rapid edits into one run.
  void scheduleAfterMutation() {
    _mutationDebounce?.cancel();
    _mutationDebounce = Timer(const Duration(seconds: 30), () {
      unawaited(syncNow(reason: 'mutation'));
    });
  }

  /// Single-flight sync run: push outbox, then pull all entities, then media.
  /// Concurrent calls coalesce onto the in-flight run.
  Future<void> syncNow({String reason = 'manual'}) {
    final Future<void>? running = _running;
    if (running != null) {
      return running;
    }
    final Future<void> run = _run(reason).whenComplete(() {
      _running = null;
    });
    _running = run;
    return run;
  }

  Future<void> _run(String reason) async {
    if (!_connectivity.isOnline) {
      debugPrint('[SYNC] Skipped ($reason): offline');
      return;
    }
    debugPrint('[SYNC] Run start ($reason)');
    try {
      state._update(phase: SyncPhase.pushing);
      final int pushed = await _push.pushAll();

      state._update(phase: SyncPhase.pulling);
      for (final String entity in pullEntities) {
        final int pulled = await _pull.pullEntity(entity);
        if (pulled > 0) {
          debugPrint('[SYNC] pulled $entity: $pulled');
        }
      }

      state._update(phase: SyncPhase.media);
      await _media.downloadPending();

      final DateTime now = DateTime.now().toUtc();
      await _db.setKv('last_sync_at', now.toIso8601String());
      state._update(phase: SyncPhase.idle, syncedAt: now);
      _consecutiveFailures = 0;
      debugPrint('[SYNC] Run done ($reason): pushed=$pushed');
    } catch (error) {
      _consecutiveFailures++;
      state._update(phase: SyncPhase.error, error: error.toString());
      debugPrint('[SYNC] Run failed ($reason): $error');
      _scheduleBackoffRetry();
    }
  }

  /// Exponential backoff with cap: 30s, 2m, 10m, 30m, then hourly.
  void _scheduleBackoffRetry() {
    const List<Duration> steps = <Duration>[
      Duration(seconds: 30),
      Duration(minutes: 2),
      Duration(minutes: 10),
      Duration(minutes: 30),
      Duration(hours: 1),
    ];
    final Duration delay =
        steps[(_consecutiveFailures - 1).clamp(0, steps.length - 1)];
    _backoffTimer?.cancel();
    _backoffTimer = Timer(delay, () {
      unawaited(syncNow(reason: 'retry'));
    });
    debugPrint('[SYNC] Retry scheduled in $delay');
  }

  /// Full resync: drop entity data + cursors (keeps auth, device id and
  /// downloaded media files), then bootstrap again. Refuses while unsynced
  /// changes exist unless [discardPending] is set.
  Future<bool> fullResync({bool discardPending = false}) async {
    final List<OutboxOp> pending = await _outbox.nextBatch(limit: 1);
    if (pending.isNotEmpty && !discardPending) {
      return false;
    }
    await _db.transaction(() async {
      await _db.delete(_db.doctors).go();
      await _db.delete(_db.chemists).go();
      await _db.delete(_db.products).go();
      await _db.delete(_db.dailyPlans).go();
      await _db.delete(_db.dcrs).go();
      await _db.delete(_db.dcrProductRows).go();
      await _db.delete(_db.usersLite).go();
      await _db.delete(_db.metadataItems).go();
      await _db.delete(_db.outboxOps).go();
      await _db.delete(_db.syncCursors).go();
      await _db.setKv('bootstrap_done', null);
    });
    state._setBootstrapDone(false);
    await bootstrap();
    return true;
  }

  void dispose() {
    _mutationDebounce?.cancel();
    _backoffTimer?.cancel();
    _pendingSub?.cancel();
    _onlineSub?.cancel();
    state.dispose();
  }
}
