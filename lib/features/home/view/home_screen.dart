import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocare/app/router/app_router.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/features/home/view/widgets/home_dashboard.dart';
import 'package:vivocare/features/home/view/widgets/plan_meet_panel.dart';
import 'package:vivocare/features/home/view/widgets/home_sidebar.dart';
import 'package:vivocare/features/home/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;
  Timer? _clockTimer;

  void _logout(HomeViewModel viewModel) {
    viewModel.resetForLogout();
    if (!mounted) {
      return;
    }
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> _) => false);
    _clearSessionAfterLogout();
  }

  Future<void> _clearSessionAfterLogout() async {
    try {
      await AuthStorage.clearSession();
    } catch (error) {
      debugPrint('[AUTH][LOGOUT] Failed to clear session: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // refresh periodically so greeting/date stay current while screen is open
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    final Object? args = ModalRoute.of(context)?.settings.arguments;
    // call initialization after the current frame so that the provider has
    // finished its own build. avoids "!_dirty" assertion when notifyListeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final HomeViewModel viewModel = context.read<HomeViewModel>();
      viewModel.initializeFromArgs(args);
      viewModel.loadCachedProducts();
      viewModel.fetchTodayPlan();
      viewModel.fetchUpcomingEvents();
    });

    _initialized = true;
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compactSidebar = constraints.maxWidth < 760;
            final double sidebarWidth = compactSidebar ? 84 : 205;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeSidebar(
                  items: viewModel.menuItems,
                  width: sidebarWidth,
                  compact: compactSidebar,
                  onItemTap: (int index) {
                    if (index == HomeViewModel.logoutMenuIndex) {
                      _logout(viewModel);
                      return;
                    }

                    if (index == HomeViewModel.performanceMenuIndex) {
                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.construction_rounded,
                                size: 64,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Work is under progress',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    if (index == HomeViewModel.addDoctorMenuIndex) {
                      Navigator.of(context).pushNamed(AppRoutes.addDoctor);
                      return;
                    }

                    if (index == HomeViewModel.addChemistMenuIndex) {
                      Navigator.of(context).pushNamed(AppRoutes.addChemist);
                      return;
                    }

                    viewModel.selectMenu(index);
                    if (index == HomeViewModel.planMeetMenuIndex) {
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
    );
  }
}
