import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocare/features/home/view/widgets/home_dashboard.dart';
import 'package:vivocare/features/home/view/widgets/home_sidebar.dart';
import 'package:vivocare/features/home/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

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
      context.read<HomeViewModel>().initializeFromArgs(args);
    });

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compactSidebar = constraints.maxWidth < 980;
            final double sidebarWidth = compactSidebar ? 90 : 220;

            return Row(
              children: [
                HomeSidebar(
                  items: viewModel.menuItems,
                  width: sidebarWidth,
                  compact: compactSidebar,
                ),
                Expanded(
                  child: HomeDashboard(
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
