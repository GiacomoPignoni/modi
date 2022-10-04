import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';

class YesOrNotDialog extends StatelessWidget {
  final String title;
  final String text;

  const YesOrNotDialog({
    required this.title,
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: Icons.help_outline_rounded,
      iconColor: theme.colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headline2
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            child: Text(
              text,
              style: theme.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: BaseDialogButtonsRow(
              cancelText: tr("no"),
              confirmText: tr("yes"),
              onCancel: () => Navigator.of(context).pop(false),
              onConfirm: () => Navigator.of(context).pop(true)
            ),
          )
        ],
      )
    );
  }
  
  static Future<bool?> show(BuildContext context, { required String text, required String title }) {
    return BaseDialog.show<bool>(
      context,
      label: "yes-or-no-dialog",
      dismissible: false,
      dialog: YesOrNotDialog(text: text, title: title)
    );
  }
}
