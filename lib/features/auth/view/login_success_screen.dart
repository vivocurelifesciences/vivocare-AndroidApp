import 'package:flutter/material.dart';
import 'package:vivocure/app/router/app_router.dart';
import 'package:vivocure/core/navigation/home_user_context.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key, required this.userContext});

  final HomeUserContext userContext;

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
    ).pushReplacementNamed(AppRoutes.home, arguments: widget.userContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageBackdrop(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AppPanel(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFFEAF8F0), Color(0xFFDDF3E8)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFCBE8D6)),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF1F9D5A),
                      size: 54,
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
                    'Welcome ${widget.userContext.userName.isEmpty ? 'User' : widget.userContext.userName}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Preparing your workspace and syncing the latest data.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
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
