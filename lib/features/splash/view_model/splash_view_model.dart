import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/navigation/home_user_context.dart';

class SplashViewModel extends ChangeNotifier {
  bool _started = false;

  void start(BuildContext context) {
    if (_started) {
      return;
    }

    _started = true;
    // Short branding beat only — startup time matters more than the logo.
    Future<void>.delayed(const Duration(milliseconds: 700), () async {
      // Session restore: a previously logged-in rep goes straight to Home —
      // with zero connectivity required. Sync catches up in the background.
      final AuthSession session = await AuthStorage.loadSession();
      final Map<String, dynamic>? profile = await AuthStorage.loadUserProfile();
      final bool expired = await AuthStorage.isSessionExpired();

      if (!context.mounted) {
        return;
      }

      if (session.hasAccessToken && profile != null && !expired) {
        unawaited(AuthStorage.touchActivity());
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.home,
          arguments: HomeUserContext(
            userName: (profile['full_name'] ?? '') as String,
            roleName: (profile['role_name'] ?? '') as String,
            employeeCode: (profile['employee_code'] ?? '') as String,
          ),
        );
        return;
      }
      if (expired) {
        // 15 days of inactivity: drop the tokens, keep the offline verifier
        // and saved username so the rep can sign back in without connectivity.
        await AuthStorage.clearSession();
      }
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }
}
