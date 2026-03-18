import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 56, this.showTagline = true});

  static const String _fullLogoAsset = 'assets/images/vivocure_logo.jpeg';
  static const String _iconAsset = 'assets/images/vivocure_logo.jpeg';
  static const double _logoAspectRatio = 671 / 767;

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    if (showTagline) {
      final double height = size * 2.2;
      final double width = height * _logoAspectRatio;

      return Image.asset(
        _fullLogoAsset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      );
    }

    return Image.asset(
      _iconAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
