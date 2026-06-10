import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/app_services.dart';
import 'package:vivocure/core/auth/auth_storage.dart';
import 'package:vivocure/core/navigation/home_user_context.dart';
import 'package:vivocure/core/network/network_exception.dart';
import 'package:vivocure/features/auth/model/login_request.dart';
import 'package:vivocure/features/auth/model/login_response.dart';
import 'package:vivocure/features/auth/repository/auth_repository.dart';

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
      // Stores the username and a salted hash verifier for offline login —
      // never the plaintext password.
      await AuthStorage.saveCredentials(username: username, password: password);
      await AuthStorage.saveSession(
        accessToken: response.data.accessToken,
        refreshToken: response.data.refreshToken,
        tokenType: response.data.tokenType,
      );
      final String resolvedName = response.data.user.fullName.isNotEmpty
          ? response.data.user.fullName
          : (response.data.username.isEmpty
                ? username
                : response.data.username);
      await AuthStorage.saveUserProfile(<String, dynamic>{
        'id': response.data.user.id,
        'full_name': resolvedName,
        'role_name': response.data.user.roleName,
        'employee_code': response.data.user.employeeCode,
        'email': response.data.user.email,
      });

      // First sync (or catch-up): runs in the background — the home screens
      // are reactive to the local database and fill in as data lands.
      unawaited(AppServices.syncEngine.bootstrap());

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
      final bool offline = error.type == NetworkExceptionType.noInternet ||
          error.type == NetworkExceptionType.timeout;
      if (offline) {
        final bool handled =
            await _tryOfflineLogin(context, username, password);
        if (handled) {
          return;
        }
        _errorMessage =
            'No connection, and offline sign-in is unavailable on this '
            'device. Connect to the internet for your first login.';
      } else {
        debugPrintSynchronously(
          '[API][LOGIN] ERROR status=${error.statusCode} type=${error.type} message=${error.message}',
        );
        _errorMessage = error.message;
      }
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

  /// Offline login: validates against the locally stored verifier and reuses
  /// the synced local data. Requires one prior online login on this device.
  Future<bool> _tryOfflineLogin(
    BuildContext context,
    String username,
    String password,
  ) async {
    final bool valid = await AuthStorage.verifyOffline(
      username: username,
      password: password,
    );
    if (!valid) {
      return false;
    }
    final Map<String, dynamic>? profile = await AuthStorage.loadUserProfile();
    if (profile == null) {
      return false;
    }
    debugPrint('[AUTH] Offline login for $username');
    if (!context.mounted) {
      return true;
    }
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.home,
      arguments: HomeUserContext(
        userName: (profile['full_name'] ?? '') as String,
        roleName: (profile['role_name'] ?? '') as String,
        employeeCode: (profile['employee_code'] ?? '') as String,
      ),
    );
    return true;
  }

  Future<void> _loadSavedCredentials() async {
    final SavedLoginCredentials credentials =
        await AuthStorage.loadSavedCredentials();
    if (_disposed) {
      return;
    }
    usernameController.text = credentials.username;
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
