import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/navigation/home_user_context.dart';
import 'package:vivocare/core/network/network_client.dart';
import 'package:vivocare/features/auth/view/add_chemist_screen.dart';
import 'package:vivocare/features/auth/view/add_doctor_screen.dart';
import 'package:vivocare/features/auth/view/login_screen.dart';
import 'package:vivocare/features/auth/view/login_success_screen.dart';
import 'package:vivocare/features/auth/view_model/login_view_model.dart';
import 'package:vivocare/features/auth/repository/auth_repository.dart';
import 'package:vivocare/features/home/view/home_screen.dart';
import 'package:vivocare/features/home/view_model/home_view_model.dart';
import 'package:vivocare/features/splash/view/splash_screen.dart';
import 'package:vivocare/features/splash/view_model/splash_view_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginSuccess = '/login-success';
  static const String home = '/home';
  static const String addDoctor = '/add-doctor';
  static const String addChemist = '/add-chemist';
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
      default:
        return MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
