import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/connectivity/connectivity_service.dart';
import 'package:vivocure/core/sync/sync_engine.dart';
import 'package:vivocure/core/theme/app_colors.dart';

/// Compact sync status strip styled to the app design system: connectivity,
/// pending-change count, last sync time, manual "Sync now" action. Tapping
/// the strip opens the sync activity / attention inbox.
class SyncStatusBar extends StatelessWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SyncState sync = context.watch<SyncState>();
    final ConnectivityService connectivity = context
        .watch<ConnectivityService>();
    final ThemeData theme = Theme.of(context);

    final bool offline = !connectivity.isOnline;
    final bool hasIssue = !offline && sync.lastError != null;

    final Color accent = offline
        ? AppColors.accentAmber
        : hasIssue
        ? AppColors.warning
        : AppColors.accentMint;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.syncInbox),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    offline
                        ? Icons.cloud_off_rounded
                        : sync.isSyncing
                        ? Icons.sync_rounded
                        : hasIssue
                        ? Icons.sync_problem_rounded
                        : Icons.cloud_done_rounded,
                    size: 16,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _statusText(sync, offline),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (sync.pendingOps > 0) ...[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${sync.pendingOps} pending',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                if (sync.isSyncing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryBlue,
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: offline
                        ? null
                        : () =>
                              AppServices.syncEngine.syncNow(reason: 'manual'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      foregroundColor: AppColors.primaryBlue,
                    ),
                    icon: const Icon(Icons.sync_rounded, size: 16),
                    label: const Text(
                      'Sync now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusText(SyncState sync, bool offline) {
    if (offline) {
      return sync.pendingOps > 0
          ? 'Offline — changes saved on this device'
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
      return 'Sync issue — tap Sync to retry';
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
