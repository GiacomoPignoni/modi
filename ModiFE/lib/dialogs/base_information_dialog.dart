import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/button.dart';

class BaseInformationDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const BaseInformationDialog({
    required this.icon,
    required this.title,
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: icon,
      iconColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headline2,
            ),
          ),
          const Divider(color: Colors.transparent),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
          const Divider(color: Colors.transparent),
          Button(
            text: tr("close"),
            onPressed: () => Navigator.of(context).pop()
          )
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context,
    {
      required IconData icon,
      required String title,
      required String text,
    }
  ) {
    return BaseDialog.show<void>(
      context,
      label: "base-information-dialog",
      dismissible: true,
      dialog: BaseInformationDialog(icon: icon, title: title, text: text)
    );
  }
}
