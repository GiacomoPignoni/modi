import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/button.dart';

class ShopPageInfoDialog extends StatelessWidget {
  const ShopPageInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: Icons.info_outline_rounded,
      iconColor: theme.colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              tr("shopPageInfoDialog.title"),
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
             tr("shopPageInfoDialog.text"),
             textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: Button(
              text: tr("close"),
              onPressed: () => Navigator.of(context).pop()
            ),
          )
        ],
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return BaseDialog.show<void>(
      context,
      label: "shop-page-info-dialog",
      dismissible: true,
      dialog: const ShopPageInfoDialog()
    );
  }
}
