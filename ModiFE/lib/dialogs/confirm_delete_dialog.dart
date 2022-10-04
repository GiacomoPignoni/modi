import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';

/// Dialog used to show a confirm message for deleting a note
class ConfirmDeleteDialog extends StatelessWidget {
  final void Function() onConfirm;
  final DateTime date;

  const ConfirmDeleteDialog({
    required this.onConfirm,
    required this.date,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      colorStyle: BaseDialogColorStyle.danger,
      icon: Icons.delete_outline_outlined,
      iconColor: theme.colorScheme.onError,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              tr("confirmDeleteDialog.title"),
              style: theme.textTheme.headline2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 50, right: 50),
            child: Text(
              tr("confirmDeleteDialog.text"),
              style: theme.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              tr("months.${date.month}") + " ${date.day}, ${date.year}",
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              tr("confirmDeleteDialog.thisProcessCannotBeUndone"),
              style: theme.textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ),
          BaseDialogButtonsRow(
            cancelText: tr("cancel"), 
            confirmText: tr("confirmDeleteDialog.deleteNote"), 
            onConfirm: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

  static Future<void> show(BuildContext context, { 
    required void Function() onConfirm,
    required DateTime date
  }) {
    return BaseDialog.show<void>(
      context,
      label: "confirm-delete-dialog",
      dismissible: false,
      dialog: ConfirmDeleteDialog(onConfirm: onConfirm, date: date)
    );
  }
}
