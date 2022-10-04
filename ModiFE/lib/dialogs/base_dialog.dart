import 'package:flutter/material.dart';
import 'package:modi/theme/colors.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button.dart';

enum BaseDialogColorStyle {
  primary,
  danger
}

/// Dialog used as base for all other dialogs
/// 
/// Also provide a static method to show a dialog with the default animation
class BaseDialog extends StatelessWidget {
  final BaseDialogColorStyle colorStyle;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final EdgeInsets? padding;

  const BaseDialog({
    this.colorStyle = BaseDialogColorStyle.primary,
    required this.icon,
    required this.iconColor,
    required this.child,
    this.padding,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Body with child
          Container(
            padding: (padding != null) ? padding!.copyWith(top: 40) : const EdgeInsets.fromLTRB(22, 40, 22, 22),
            decoration: BoxDecoration(
              color: theme.primaryColorLight,
              borderRadius: defaultBorderRadius,
              boxShadow: const [ defaultShadow ]
            ),
            child: child
          ),
          // Icon header
          Positioned(
            top: -50,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColorLight,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    tileMode: TileMode.clamp,
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: _getColors(theme)
                  ),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 60,
                ),
              ),
            )
          )
        ]
      ),
    );
  }

  List<Color> _getColors(ThemeData theme) {
    switch(colorStyle) {
      case BaseDialogColorStyle.primary:
        return [
          theme.colorScheme.secondary,
          theme.colorScheme.primary
        ];
      case BaseDialogColorStyle.danger:
        return [
          theme.colorScheme.error,
          dangerColorVariant
        ];
    }
  }

  static Future<T?> show<T>(
    BuildContext context,
    { 
      required Widget dialog,
      required String label,
      required bool dismissible
    }
  ) {
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: label,
      barrierDismissible: dismissible,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnimation = CurvedAnimation(
          parent: anim1,
          curve: Curves.bounceOut,
          reverseCurve: Curves.fastOutSlowIn
        );

        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) => dialog
    );
  }
}

class BaseDialogButtonsRow extends StatelessWidget {
  final String confirmText;
  final void Function() onConfirm;

  final String? cancelText;
  final void Function()? onCancel;

  final ButtonColorStyle colorStyle;

  const BaseDialogButtonsRow({
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.colorStyle = ButtonColorStyle.primary,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Visibility(
            visible: cancelText != null,
            child: Button(
              text: cancelText ?? "",
              onPressed: (onCancel != null) ? onCancel! : () => Navigator.of(context).pop(),
              colorStyle: ButtonColorStyle.grey,
            ),
          ),
        ),
        const VerticalDivider(color: Colors.transparent, width: 10),
        Expanded(
          child: Button(
            text: confirmText,
            colorStyle: colorStyle,
            onPressed: onConfirm
          ),
        )
      ],
    );
  }
}
