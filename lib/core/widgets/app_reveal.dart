import 'dart:async';

import 'package:flutter/material.dart';

class AppReveal extends StatefulWidget {
  const AppReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
    this.offset = const Offset(0, 18),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  State<AppReveal> createState() => _AppRevealState();
}

class _AppRevealState extends State<AppReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }

    _delayTimer = Timer(widget.delay, _controller.forward);
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double value = _animation.value;
        final Offset translatedOffset = Offset(
          widget.offset.dx * (1 - value),
          widget.offset.dy * (1 - value),
        );

        return Opacity(
          opacity: value,
          child: Transform.translate(offset: translatedOffset, child: child),
        );
      },
    );
  }
}
