import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/core/config/api_config.dart';
import 'package:vivocure/core/navigation/home_user_context.dart';
import 'package:vivocure/core/network/network_client.dart';
import 'package:vivocure/features/auth/view/add_chemist_screen.dart';
import 'package:vivocure/features/auth/view/add_doctor_screen.dart';
import 'package:vivocure/features/auth/view/login_screen.dart';
import 'package:vivocure/features/auth/view/login_success_screen.dart';
import 'package:vivocure/features/auth/view_model/login_view_model.dart';
import 'package:vivocure/features/auth/repository/auth_repository.dart';
import 'package:vivocure/features/home/view/home_screen.dart';
import 'package:vivocure/features/execution/view/execution_screen.dart';
import 'package:vivocure/features/execution/view/performance_screen.dart';
import 'package:vivocure/features/home/view/product_reorder_screen.dart';
import 'package:vivocure/features/home/view_model/home_view_model.dart';
import 'package:vivocure/features/splash/view/splash_screen.dart';
import 'package:vivocure/features/splash/view_model/splash_view_model.dart';
import 'package:vivocure/features/sync/view/sync_inbox_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginSuccess = '/login-success';
  static const String home = '/home';
  static const String addDoctor = '/add-doctor';
  static const String addChemist = '/add-chemist';
  static const String syncInbox = '/sync-inbox';
  static const String reorderProducts = '/reorder-products';
  static const String execution = '/execution';
  static const String performance = '/performance';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<SplashViewModel>(
            create: (_) => SplashViewModel(),
            child: const SplashScreen(),
          ),
        );
      case AppRoutes.login:
        final AuthRepository authRepository = AuthRepositoryImpl(
          networkClient: NetworkClient(
            scheme: ApiConfig.scheme,
            host: ApiConfig.host,
          ),
        );

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<LoginViewModel>(
            create: (_) => LoginViewModel(authRepository: authRepository),
            child: const LoginScreen(),
          ),
        );
      case AppRoutes.loginSuccess:
        final HomeUserContext homeUserContext = HomeUserContext.fromRouteArgs(
          settings.arguments,
        );

        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => LoginSuccessScreen(userContext: homeUserContext),
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(),
            child: const HomeScreen(),
          ),
        );
      case AppRoutes.addDoctor:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AddDoctorScreen(),
        );
      case AppRoutes.addChemist:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AddChemistScreen(),
        );
      case AppRoutes.syncInbox:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SyncInboxScreen(),
        );
      case AppRoutes.reorderProducts:
        // Optional List<String> of product ids = arrange only that subset
        // (presentation prep) and return the new order; null = full catalog.
        final Object? reorderArgs = settings.arguments;
        final List<String>? selectedIds = reorderArgs is List<String>
            ? reorderArgs
            : null;
        return MaterialPageRoute<List<String>>(
          settings: settings,
          builder: (_) => ProductReorderScreen(selectedIds: selectedIds),
        );
      case AppRoutes.execution:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ExecutionScreen(),
        );
      case AppRoutes.performance:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PerformanceScreen(),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
