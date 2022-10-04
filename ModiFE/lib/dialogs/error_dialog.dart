import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/button.dart';

/// Dialog used to show an error message
/// 
/// It's showen by the [MessageService]
class ErrorDialog extends StatelessWidget {
  final String text;

  const ErrorDialog({
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      colorStyle: BaseDialogColorStyle.danger,
      icon: Icons.close_rounded,
      iconColor: theme.colorScheme.onError,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr("errors.error"),
            style: theme.textTheme.headline2!.copyWith(color: theme.colorScheme.error),
            textAlign: TextAlign.center
          ),
          Text(
            text,
            style: theme.textTheme.bodyText2,
            textAlign: TextAlign.center
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Button(
              text: tr("close"),
              onPressed: () => Navigator.of(context).pop(),
              colorStyle: ButtonColorStyle.danger,
            ),
          )
        ],
      )
    );
  }
  
  static Future<void> show(BuildContext context, { required String text }) {
    return BaseDialog.show<void>(
      context,
      label: "error-dialog",
      dismissible: true,
      dialog: ErrorDialog(text: text)
    );
  }
}
