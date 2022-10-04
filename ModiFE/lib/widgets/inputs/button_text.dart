import 'package:flutter/material.dart';

enum ButtonTextColorStyle {
  primary,
  danger,
  grey
}


/// A tappable text
/// 
/// A tabble text with color taken from primary and primary varint for darker version
class ButtonText extends StatefulWidget {
  /// Color user in the button
  /// 
  /// Default [ButtonTextColorStyle.primary]
  /// 
  /// [ButtonTextColorStyle.primary] use primary and primary variant color from [ThemeData] [ColorScheme]
  /// [ButtonTextColorStyle.danger] use error color from [ThemeData] [ColorScheme] and automatically generate darker color
  /// [ButtonTextColorStyle.grey] use [Colors.grey] and [Colors.grey[600]]
  final ButtonTextColorStyle colorStyle;

  final String text;
  final void Function() onPressed;

  const ButtonText({
    required this.text,
    required this.onPressed,
    this.colorStyle = ButtonTextColorStyle.primary,
    Key? key
  }) : super(key: key);

  @override
  State<ButtonText> createState() => _ButtonTextState();
}

class _ButtonTextState extends State<ButtonText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150)
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final animation = ColorTween(
      begin: _getColor(theme),
      end: _getColorVariant(theme)
    ).animate(_controller);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp:  (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Text(
            widget.text,
            style: theme.textTheme.bodyText2!.copyWith(color: animation.value)
          );
        }
      ),
    );
  }

  Color _getColor(ThemeData theme) {
    switch(widget.colorStyle) {
      case ButtonTextColorStyle.primary:
        return theme.colorScheme.primary;
      case ButtonTextColorStyle.danger:
        return theme.colorScheme.error;
      case ButtonTextColorStyle.grey:
        return Colors.grey;
    }
  }

  Color _getColorVariant(ThemeData theme) {
    switch(widget.colorStyle) {
      case ButtonTextColorStyle.primary:
        return theme.colorScheme.primaryContainer;
      case ButtonTextColorStyle.danger:
        return HSLColor.fromColor(theme.colorScheme.error).withLightness(0.7).toColor();
      case ButtonTextColorStyle.grey:
        return Colors.grey[600]!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
