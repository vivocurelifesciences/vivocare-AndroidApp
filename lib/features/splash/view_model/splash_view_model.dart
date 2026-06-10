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
    Future<void>.delayed(const Duration(seconds: 2), () async {
      // Session restore: a previously logged-in rep goes straight to Home —
      // with zero connectivity required. Sync catches up in the background.
      final AuthSession session = await AuthStorage.loadSession();
      final Map<String, dynamic>? profile = await AuthStorage.loadUserProfile();

      if (!context.mounted) {
        return;
      }

      if (session.hasAccessToken && profile != null) {
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
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }
}
