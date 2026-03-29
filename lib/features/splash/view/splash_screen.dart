import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivocure/core/widgets/app_page_backdrop.dart';
import 'package:vivocure/core/widgets/app_panel.dart';
import 'package:vivocure/core/widgets/app_logo.dart';
import 'package:vivocure/features/splash/view_model/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<SplashViewModel>().start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageBackdrop(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AppPanel(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 132, showTagline: true),
                  const SizedBox(height: 20),
                  Text(
                    'Preparing your field workspace',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
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
