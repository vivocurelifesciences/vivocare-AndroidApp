import 'package:flutter/material.dart';
import 'package:vivocare/app/router/app_router.dart';
import 'package:vivocare/core/theme/app_theme.dart';

class VivoCareApp extends StatelessWidget {
  const VivoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VivoCare',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
