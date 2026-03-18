import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/products/product_cache_service.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/features/home/view/widgets/home_dashboard.dart';
import 'package:vivocure/features/home/view/widgets/home_sidebar.dart';
import 'package:vivocure/features/home/view/widgets/plan_meet_panel.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;
  bool _isLoggingOut = false;
  Timer? _clockTimer;

  Future<void> _logout(HomeViewModel viewModel) async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      viewModel.resetForLogout();
      await ProductCacheService.clearCachedProducts();
      await AuthStorage.clearSession();

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to finish logout cleanup. Please try again.'),
        ),
      );
      setState(() {
        _isLoggingOut = false;
      });
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

    if (_initialized) {
      return;
    }

    final Object? args = ModalRoute.of(context)?.settings.arguments;
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
      body: AppPageBackdrop(
        child: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (index == HomeViewModel.addDoctorMenuIndex) {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.addDoctor);
                            return;
                          }

                          if (index == HomeViewModel.addChemistMenuIndex) {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.addChemist);
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
