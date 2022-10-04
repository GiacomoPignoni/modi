import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/models/res/note_res.dart';
import 'package:modi/pages/shop/shop_page.dart';
import 'package:modi/services/navigation_service.dart';

/// Dialog shown when user make a combo
class ComboDialog extends StatelessWidget {
  final ComboType comboType;
  final int gainedTokens;
  final int tokens;

  const ComboDialog({
    required this.comboType,
    required this.gainedTokens,
    required this.tokens,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: Icons.celebration,
      iconColor: theme.colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr("comboDialog.title"),
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center
          ),
          Text(
            tr("comboDialog.text", args: [tr("combos.${comboType.toString().split(".")[1]}"), gainedTokens.toString()]),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              tr("comboDialog.subText", args: [tokens.toString()]),
              style: theme.textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: BaseDialogButtonsRow(
              cancelText: tr("comboDialog.goToShop"),
              confirmText: tr("close"),
              onCancel: () {
                Navigator.of(context).pop();
                GetIt.I.get<NavigationService>().pushNamed(ShopPage.routePath);
              },
              onConfirm: () => Navigator.of(context).pop()
            ),
          )
        ],
      )
    );
  }
  
  static Future<void> show(
    BuildContext context, 
    { 
      required ComboType comboType,
      required int gainedTokens,
      required int tokens,
    }
  ) {
    return BaseDialog.show<void>(
      context,
      label: "combo-dialog",
      dismissible: true,
      dialog: ComboDialog(comboType: comboType, gainedTokens: gainedTokens, tokens: tokens)
    );
  }
}
