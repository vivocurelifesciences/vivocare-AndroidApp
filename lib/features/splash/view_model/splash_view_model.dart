import 'package:flutter/material.dart';
import 'package:vivocare/app/router/app_router.dart';

class SplashViewModel extends ChangeNotifier {
  bool _started = false;

  void start(BuildContext context) {
    if (_started) {
      return;
    }

    _started = true;
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    });
  }
}
