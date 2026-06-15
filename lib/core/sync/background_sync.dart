import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/auth/auth_storage.dart';

const String periodicSyncTask = 'vivocure.periodic-sync';
const String oneShotSyncTask = 'vivocure.oneshot-sync';

/// Background isolate entry point. Spins up the same service stack as the
/// foreground app and runs one sync pass. Best-effort by design: the
/// guaranteed sync path is foreground-on-open; this accelerates delivery
/// when the app is closed.
@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((
    String task,
    Map<String, dynamic>? inputData,
  ) async {
    try {
      final session = await AuthStorage.loadSession();
      if (!session.hasAccessToken) {
        return true; // not logged in — nothing to sync
      }
      await AppServices.init();
      await AppServices.syncEngine.syncNow(reason: 'background:$task');
      return AppServices.syncEngine.state.lastError == null;
    } catch (error) {
      debugPrint('[SYNC][BG] failed: $error');
      // Returning false lets WorkManager apply its own backoff/retry policy.
      return false;
    }
  });
}

class BackgroundSync {
  /// Registers the periodic job (Android). Safe to call on every startup —
  /// existing registration is kept/replaced.
  static Future<void> register() async {
    try {
      await Workmanager().initialize(backgroundSyncDispatcher);
      await Workmanager().registerPeriodicTask(
        periodicSyncTask,
        periodicSyncTask,
        frequency: const Duration(minutes: 45),
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        backoffPolicy: BackoffPolicy.exponential,
      );
    } catch (error) {
      // iOS or platforms without WorkManager support: foreground sync only.
      debugPrint('[SYNC][BG] registration skipped: $error');
    }
  }

  /// Expedited one-shot when the outbox is non-empty (e.g. user backgrounds
  /// the app right after creating DCRs).
  static Future<void> scheduleOneShot() async {
    try {
      await Workmanager().registerOneOffTask(
        '$oneShotSyncTask-${DateTime.now().millisecondsSinceEpoch}',
        oneShotSyncTask,
        constraints: Constraints(networkType: NetworkType.connected),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (error) {
      debugPrint('[SYNC][BG] one-shot skipped: $error');
    }
  }
}
