import 'package:flutter/material.dart';
import 'package:vivocure/core/theme/app_colors.dart';

class AppPageBackdrop extends StatelessWidget {
  const AppPageBackdrop({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.backgroundTop,
            AppColors.background,
            AppColors.backgroundBottom,
          ],
          stops: <double>[0, 0.52, 1],
        ),
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(
            top: -90,
            right: -30,
            child: _BackdropOrb(
              size: 240,
              colors: <Color>[Color(0x352D8BE6), Color(0x002D8BE6)],
            ),
          ),
          const Positioned(
            left: -70,
            bottom: -90,
            child: _BackdropOrb(
              size: 260,
              colors: <Color>[Color(0x2238C0A1), Color(0x0038C0A1)],
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
