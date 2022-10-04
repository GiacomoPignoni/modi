import 'package:flutter/material.dart';
import 'package:modi/theme/colors.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/state_management/null_value_notifier_wrapper.dart';
import 'package:modi/widgets/visual/spinner.dart';

enum ButtonColorStyle {
  primary,
  danger,
  grey
}

/// A button with gradient color
/// 
/// It's the common button used in all the app
class Button extends StatefulWidget {
  /// Color user in the button
  /// 
  /// Default [ButtonColorStyle.primary]
  /// 
  /// [ButtonColorStyle.primary] use primary and primary variant color from [ThemeData] [ColorScheme]
  /// [ButtonColorStyle.danger] use error color from [ThemeData] [ColorScheme] and automatically generate darker color
  /// [ButtonColorStyle.grey] use [Colors.grey] and [Colors.grey[600]]
  final ButtonColorStyle colorStyle;

  /// Value notifer use to show loader inside the button
  /// 
  /// The button is disabled when value is true
  final ValueNotifier<bool>? loading;

  final String? text;
  final void Function() onPressed;
  final IconData? icon;

  const Button({
    this.text,
    required this.onPressed,
    this.icon,
    this.loading,
    this.colorStyle = ButtonColorStyle.primary,
    Key? key
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NullValueNotifierWrapper<bool>(
      defaultValue: false,
      listenable: widget.loading,
      builder: (context, loading) {
        return GestureDetector(
          onTapDown: (loading) ? null : (_) => setState(() => isDown = true),
          onTapUp: (loading) ? null : (_) => setState(() => isDown = false),
          onTapCancel: (loading) ? null : () => setState(() => isDown = false),
          onTap: (loading) ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 45,
            curve: Curves.ease,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: defaultBorderRadius,
              gradient: LinearGradient(
                tileMode: TileMode.clamp,
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: _getColors(theme)
              ),
              boxShadow: (isDown) ? null : const [ defaultShadow ]
            ),
            child: (loading)
            ? SizedBox(width: 25, height: 25, child: Spinner(color: theme.colorScheme.onPrimary))
            : FittedBox(
              child: (widget.text != null) 
              ? Text(
                widget.text!,
                style: theme.textTheme.button,
              )
              : Icon(
                widget.icon,
                color: _getIconColor(theme),
              )
            ),
          ),
        );
      }
    );
  }

  List<Color> _getColors(ThemeData theme) {
    switch(widget.colorStyle) {
      case ButtonColorStyle.primary:
        return [
          theme.colorScheme.secondary,
          theme.colorScheme.primary
        ];
      case ButtonColorStyle.danger:
        return [
          dangerColor,
          dangerColorVariant
        ];
      case ButtonColorStyle.grey:
        return [
          Colors.grey,
          Colors.grey[600]!
        ];
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch(widget.colorStyle) {
      case ButtonColorStyle.primary:
        return theme.colorScheme.onPrimary;
      case ButtonColorStyle.danger:
        return theme.colorScheme.onError;
      case ButtonColorStyle.grey:
        return theme.colorScheme.onBackground;
    }
  }
}
