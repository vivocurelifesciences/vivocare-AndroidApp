import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:vivocure/app/router/app_route_observer.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/connectivity/connectivity_service.dart';
import 'package:vivocure/core/sync/background_sync.dart';
import 'package:vivocure/core/sync/sync_engine.dart';
import 'package:vivocure/core/theme/app_theme.dart';

class VivocureApp extends StatefulWidget {
  const VivocureApp({super.key});

  @override
  State<VivocureApp> createState() => _VivocureAppState();
}

class _VivocureAppState extends State<VivocureApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(AppServices.syncEngine.syncNow(reason: 'resume'));
    } else if (state == AppLifecycleState.paused &&
        AppServices.syncEngine.state.pendingOps > 0) {
      // Unsynced work and the user is leaving: ask WorkManager to deliver it.
      unawaited(BackgroundSync.scheduleOneShot());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<SyncState>.value(
          value: AppServices.syncEngine.state,
        ),
        ChangeNotifierProvider<ConnectivityService>.value(
          value: AppServices.connectivity,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vivocure',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorObservers: <NavigatorObserver>[appRouteObserver],
      ),
    );
  }
}
