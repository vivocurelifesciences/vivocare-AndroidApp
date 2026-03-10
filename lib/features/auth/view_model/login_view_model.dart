import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vivocare/app/router/app_router.dart';
import 'package:vivocare/core/auth/auth_storage.dart';
import 'package:vivocare/core/config/api_config.dart';
import 'package:vivocare/core/navigation/home_user_context.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/core/products/product_cache_service.dart';
import 'package:vivocare/features/auth/model/login_request.dart';
import 'package:vivocare/features/auth/model/login_response.dart';
import 'package:vivocare/features/auth/repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _loadSavedCredentials();
  }

  final AuthRepository _authRepository;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _disposed = false;

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (_isLoading) {
      return;
    }

    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String loginUrl =
        '${ApiConfig.scheme}://${ApiConfig.host}${ApiConfig.apiVersionPath}/auth/login';
    debugPrint(
      'Login button pressed. username="$username", password="$password"',
    );
    debugPrintSynchronously('[API] LOGIN_URL: $loginUrl');

    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter both username and password.';
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final LoginRequest request = LoginRequest(
        identifier: username,
        password: password,
      );
      final LoginResponse response = await _authRepository.login(request);
      await AuthStorage.saveCredentials(username: username, password: password);
      await AuthStorage.saveSession(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
        tokenType: response.data.tokenType,
      );
      try {
        final AuthSession session = AuthSession(
          accessToken: response.data.accessToken,
          refreshToken: response.data.refreshToken,
          tokenType: response.data.tokenType,
        );
        await ProductCacheService.syncProductsAfterLogin(session: session);
      } catch (error) {
        debugPrintSynchronously('[PRODUCTS] Login-time sync failed: $error');
      }
      final String resolvedName = response.data.user.fullName.isNotEmpty
          ? response.data.user.fullName
          : (response.data.username.isEmpty
                ? username
                : response.data.username);
      final HomeUserContext homeUserContext = HomeUserContext(
        userName: resolvedName,
        roleName: response.data.user.roleName,
        employeeCode: response.data.user.employeeCode,
      );

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.loginSuccess,
        arguments: homeUserContext,
      );
    } on NetworkException catch (error) {
      debugPrintSynchronously(
        '[API][LOGIN] ERROR status=${error.statusCode} type=${error.type} message=${error.message} data=${error.data}',
      );
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Unable to login right now. Please try again.';
    } finally {
      _isLoading = false;
      // only notify if still mounted; after navigation the login provider
      // may be unmounted, and notifying during the home route build can
      // trigger the "!_dirty" assertion.
      if (context.mounted) {
        notifyListeners();
      }
    }
  }

  Future<void> _loadSavedCredentials() async {
    final SavedLoginCredentials credentials =
        await AuthStorage.loadSavedCredentials();
    if (_disposed) {
      return;
    }
    usernameController.text = credentials.username;
    passwordController.text = credentials.password;
  }

  @override
  void dispose() {
    _disposed = true;
    usernameController.dispose();
    passwordController.dispose();
    _authRepository.dispose();
    super.dispose();
  }
}
