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
  /// Cancels any background sync work previously registered by older builds.
  /// Sync is now manual-only, so no background job is registered; this just
  /// tears down anything an existing install may still have scheduled.
  static Future<void> cancelAll() async {
    try {
      await Workmanager().initialize(backgroundSyncDispatcher);
      await Workmanager().cancelAll();
    } catch (error) {
      // iOS or platforms without WorkManager support: nothing to cancel.
      debugPrint('[SYNC][BG] cancel skipped: $error');
    }
  }
}
