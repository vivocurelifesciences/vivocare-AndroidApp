import 'package:flutter/material.dart';
import 'package:vivocare/app/router/app_router.dart';
import 'package:vivocare/core/network/network_exception.dart';
import 'package:vivocare/features/auth/model/login_request.dart';
import 'package:vivocare/features/auth/model/login_response.dart';
import 'package:vivocare/features/auth/repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
        username: username,
        password: password,
      );
      final LoginResponse response = await _authRepository.login(request);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.loginSuccess,
        arguments: response.data.username.isEmpty
            ? username
            : response.data.username,
      );
    } on NetworkException catch (error) {
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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _authRepository.dispose();
    super.dispose();
  }
}
