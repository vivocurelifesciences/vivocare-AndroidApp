import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vivocure/core/theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({
    super.key,
    this.label,
    this.color = AppColors.primaryBlue,
    this.dotSize = 10,
  });

  final String? label;
  final Color color;
  final double dotSize;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? labelStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600);

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(3, (int index) {
                final double wave = math.sin(
                  ((_controller.value * math.pi * 2) - (index * 0.55)),
                );
                final double scale = 0.7 + ((wave + 1) * 0.18);
                final double opacity = 0.35 + ((wave + 1) * 0.3);

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.dotSize * 0.22,
                  ),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Container(
                        width: widget.dotSize,
                        height: widget.dotSize,
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            if (widget.label != null) ...[
              const SizedBox(height: 10),
              Text(
                widget.label!,
                style: labelStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}
