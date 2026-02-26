import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 56, this.showTagline = true});

  static const String _logoAsset = 'assets/images/vivocare_logo.jpeg';
  static const double _logoAspectRatio = 671 / 767;

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    if (showTagline) {
      final double height = size * 2.2;
      final double width = height * _logoAspectRatio;

      return Image.asset(
        _logoAsset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }

    return ClipOval(
      child: Image.asset(
        _logoAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.22),
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
