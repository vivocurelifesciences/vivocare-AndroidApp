import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/app/router/app_route_observer.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/sync/sync_engine.dart';
import 'package:vivocure/core/widgets/app_alert_dialog.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/sync_status_bar.dart';
import 'package:vivocure/features/home/view/widgets/home_dashboard.dart';
import 'package:vivocure/features/home/view/widgets/home_sidebar.dart';
import 'package:vivocure/features/home/view/widgets/plan_meet_panel.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _initialized = false;
  bool _isLoggingOut = false;
  bool _isSyncListenerAttached = false;
  SyncPhase _lastSeenSyncPhase = SyncPhase.idle;
  Timer? _clockTimer;
  PageRoute<dynamic>? _subscribedRoute;

  Future<void> _logout(HomeViewModel viewModel) async {
    if (_isLoggingOut) {
      return;
    }

    // Unsynced field work would be lost: give the rep a chance to sync.
    final SyncState syncState = AppServices.syncEngine.state;
    if (syncState.pendingOps > 0) {
      final bool? proceed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Unsynced changes'),
          content: Text(
            'You have ${syncState.pendingOps} change(s) not yet synced to the '
            'server. Logging out will permanently discard them.\n\n'
            'Connect to the internet and press "Sync now" first.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) {
        return;
      }
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      viewModel.resetForLogout();
      await AppServices.clearLocalDataOnLogout();
      await AuthStorage.clearAll();

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> _) => false);
    } catch (error) {
      debugPrint('[AUTH][LOGOUT] Failed to clear local logout data: $error');
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoggingOut = false;
      });
      await AppAlertDialog.showError(
        context: context,
        message: 'Unable to finish logout cleanup. Please try again.',
      );
    }
  }

  Future<void> _refreshHomeApis({bool includePlanMeet = true}) async {
    if (!mounted) {
      return;
    }

    final HomeViewModel viewModel = context.read<HomeViewModel>();
    final List<Future<void>> refreshTasks = <Future<void>>[
      viewModel.fetchTodayPlan(),
      viewModel.fetchUpcomingEvents(),
    ];

    if (includePlanMeet && viewModel.isPlanMeetSelected) {
      refreshTasks.add(
        viewModel.fetchPlanMeetEntries(
          visitDate: viewModel.currentPlanMeetDate,
        ),
      );
    }

    await Future.wait<void>(refreshTasks);
  }

  /// When a sync run finishes, re-read everything from the local DB so
  /// freshly pulled data (and server-assigned codes) appear immediately.
  void _handleSyncStateChanged() {
    if (!mounted) {
      return;
    }
    final SyncPhase phase = AppServices.syncEngine.state.phase;
    final bool justFinished = _lastSeenSyncPhase != SyncPhase.idle &&
        phase == SyncPhase.idle;
    _lastSeenSyncPhase = phase;
    if (justFinished) {
      context.read<HomeViewModel>().loadCachedProducts();
      _refreshHomeApis();
    }
  }

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ModalRoute<dynamic>? currentRoute = ModalRoute.of(context);
    if (currentRoute is PageRoute<dynamic> &&
        currentRoute != _subscribedRoute) {
      if (_subscribedRoute != null) {
        appRouteObserver.unsubscribe(this);
      }
      _subscribedRoute = currentRoute;
      appRouteObserver.subscribe(this, currentRoute);
    }

    if (!_isSyncListenerAttached) {
      AppServices.syncEngine.state.addListener(_handleSyncStateChanged);
      _isSyncListenerAttached = true;
    }

    if (_initialized) {
      return;
    }

    final Object? args = ModalRoute.of(context)?.settings.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel viewModel = context.read<HomeViewModel>();
      viewModel.initializeFromArgs(args);
      viewModel.loadCachedProducts();
      _refreshHomeApis(includePlanMeet: false);
      // Day-start catch-up sync (no-op when offline).
      unawaited(AppServices.syncEngine.syncNow(reason: 'home-open'));
    });

    _initialized = true;
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    if (_isSyncListenerAttached) {
      AppServices.syncEngine.state.removeListener(_handleSyncStateChanged);
    }
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    _refreshHomeApis();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: AppPageBackdrop(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  const SyncStatusBar(),
                  Expanded(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final bool compactSidebar = constraints.maxWidth < 760;
                        final double sidebarWidth = compactSidebar ? 92 : 228;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HomeSidebar(
                              items: viewModel.menuItems,
                              width: sidebarWidth,
                              compact: compactSidebar,
                              onItemTap: (int index) {
                                if (_isLoggingOut) {
                                  return;
                                }

                                if (index == HomeViewModel.logoutMenuIndex) {
                                  _logout(viewModel);
                                  return;
                                }

                                if (index ==
                                    HomeViewModel.executionMenuIndex) {
                                  AppAlertDialog.showInfo(
                                    context: context,
                                    title: 'Execution',
                                    message: 'Work is under progress',
                                  );
                                  return;
                                }

                                if (index ==
                                    HomeViewModel.addDoctorMenuIndex) {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.addDoctor);
                                  return;
                                }

                                if (index ==
                                    HomeViewModel.addChemistMenuIndex) {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.addChemist);
                                  return;
                                }

                                viewModel.selectMenu(index);
                                if (index ==
                                    HomeViewModel.planMeetMenuIndex) {
                                  viewModel.fetchPlanMeetEntries();
                                }
                              },
                            ),
                            Expanded(
                              child: viewModel.isPlanMeetSelected
                                  ? PlanMeetPanel(
                                      viewModel: viewModel,
                                      compact: compactSidebar,
                                    )
                                  : HomeDashboard(
                                      viewModel: viewModel,
                                      compact: compactSidebar,
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoggingOut)
              Positioned.fill(
                child: ColoredBox(
                  color: const Color(0x88000000),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2.6),
                          ),
                          SizedBox(height: 12),
                          Text('Logging out and clearing local data...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
