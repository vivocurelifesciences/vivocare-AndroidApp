import 'package:flutter/material.dart';
import 'package:vivocure/app/router/app_route_observer.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/theme/app_theme.dart';

class VivocureApp extends StatelessWidget {
  const VivocureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vivocure',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: <NavigatorObserver>[appRouteObserver],
    );
  }
}
