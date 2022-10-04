import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/pages/partner/partner_page.dart';

class PartnerRequestDialog extends StatelessWidget {
  final String partnerNickname;

  const PartnerRequestDialog({
    required this.partnerNickname,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: Icons.people_alt_outlined,
      iconColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              tr("partnerRequestDialog.title"),
              textAlign: TextAlign.center,
              style: theme.textTheme.headline2,
            ),
          ),
          const Divider(color: Colors.transparent),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: tr("partnerRequestDialog.text"),
              style: theme.textTheme.bodyText2,
              children: [
                TextSpan(
                  text: partnerNickname,
                  style: const TextStyle(fontWeight: FontWeight.bold)
                )
              ],
            )
          ),
          const Divider(color: Colors.transparent),
          BaseDialogButtonsRow(
            confirmText: tr("partnerRequestDialog.partnerPage"),
            cancelText: tr("cancel"),
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(PartnerPage.routePath);
            }
          )
        ],
      ),
    );
  }

  static Future<T?> show<T>(BuildContext context, { required String partnerNickname }) {
    return BaseDialog.show(
      context,
      label: "partner-request-dialog",
      dismissible: false,
      dialog: PartnerRequestDialog(partnerNickname: partnerNickname)
    );
  }
}
