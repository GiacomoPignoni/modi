import 'package:flutter/material.dart';

/// A tappable colored icon
class ButtonIcon extends StatefulWidget {
  final IconData icon;

  /// Icons size, default 30
  final double iconSize;

  /// Icon color
  /// 
  /// If [Null] will be used the primary color with primary varint for the darker color
  /// 
  /// If not [Null], the darker color will be automatically generated
  final Color? color;

  final void Function() onPressed;

  const ButtonIcon({
    required this.icon,
    this.iconSize = 30,
    this.color,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  State<ButtonIcon> createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150)
  );

  @override
  Widget build(BuildContext context) {
    final animation = _generateAnimation();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp:  (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Icon(
            widget.icon,
            color: animation.value,
            size: widget.iconSize,
          );
        }
      ),
    );
  }

  _generateAnimation() {
    final theme = Theme.of(context);

    if(widget.color != null) {
      return  ColorTween(
        begin: widget.color,
        end: HSLColor.fromColor(widget.color!).withLightness(0.5).toColor()
      ).animate(_controller);
    } else {
      return  ColorTween(
        begin: theme.colorScheme.primary,
        end: theme.colorScheme.primaryContainer
      ).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
