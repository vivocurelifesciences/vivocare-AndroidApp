import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/connectivity/connectivity_service.dart';
import 'package:vivocure/core/sync/sync_engine.dart';

/// Compact sync status strip: connectivity, pending-change count, last sync
/// time, manual "Sync now" action. Tapping the warning chip opens the sync
/// inbox (changes needing attention).
class SyncStatusBar extends StatelessWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SyncState sync = context.watch<SyncState>();
    final ConnectivityService connectivity =
        context.watch<ConnectivityService>();
    final ThemeData theme = Theme.of(context);

    final bool offline = !connectivity.isOnline;
    final Color background = offline
        ? Colors.orange.shade50
        : sync.lastError != null
            ? Colors.red.shade50
            : Colors.green.shade50;

    return Material(
      color: background,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.syncInbox),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: <Widget>[
              Icon(
                offline
                    ? Icons.cloud_off
                    : sync.isSyncing
                        ? Icons.sync
                        : sync.lastError != null
                            ? Icons.sync_problem
                            : Icons.cloud_done,
                size: 18,
                color: offline
                    ? Colors.orange.shade700
                    : sync.lastError != null
                        ? Colors.red.shade700
                        : Colors.green.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _statusText(sync, offline),
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (sync.pendingOps > 0)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${sync.pendingOps} pending',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              if (sync.isSyncing)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                InkWell(
                  onTap: offline
                      ? null
                      : () => AppServices.syncEngine.syncNow(reason: 'manual'),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Sync now',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: offline
                            ? theme.disabledColor
                            : theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(SyncState sync, bool offline) {
    if (offline) {
      return sync.pendingOps > 0
          ? 'Offline — changes saved on device'
          : 'Offline — all data available';
    }
    if (sync.isSyncing) {
      switch (sync.phase) {
        case SyncPhase.pushing:
          return 'Syncing your changes…';
        case SyncPhase.pulling:
          return 'Updating data…';
        case SyncPhase.media:
          return 'Downloading images…';
        default:
          return 'Syncing…';
      }
    }
    if (sync.lastError != null) {
      return 'Sync issue — will retry automatically';
    }
    final DateTime? last = sync.lastSyncAt;
    if (last == null) {
      return 'Not synced yet';
    }
    final Duration ago = DateTime.now().toUtc().difference(last);
    if (ago.inMinutes < 1) {
      return 'Synced just now';
    }
    if (ago.inHours < 1) {
      return 'Synced ${ago.inMinutes} min ago';
    }
    if (ago.inHours < 24) {
      return 'Synced ${ago.inHours} h ago';
    }
    return 'Synced ${ago.inDays} d ago';
  }
}
