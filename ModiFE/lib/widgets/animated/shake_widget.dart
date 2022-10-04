import 'dart:math';

import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;

  const ShakeWidget({
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 500),
    Key? key,
  }) : super(key: key);

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this, 
    duration: widget.duration
  );

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    animationController.dispose();
    super.dispose();
  }
}
