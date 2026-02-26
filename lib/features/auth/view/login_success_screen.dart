import 'package:flutter/material.dart';
import 'package:vivocare/app/router/app_router.dart';
import 'package:vivocare/core/theme/app_colors.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key, required this.username});

  final String username;

  @override
  State<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1400), _navigateToHome);
  }

  void _navigateToHome() {
    if (_navigated || !mounted) {
      return;
    }

    _navigated = true;
    Navigator.of(
      context,
    ).pushReplacementNamed(AppRoutes.home, arguments: widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x110C2A4A),
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF8F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF1F9D5A),
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Login Successful',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome ${widget.username.isEmpty ? 'User' : widget.username}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _navigateToHome,
                    child: const Text('Continue to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
