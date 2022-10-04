import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/models/shop_product.dart';

class ShopProductDetailsDialog extends StatelessWidget {
  final int price;
  final ShopProduct product;

  const ShopProductDetailsDialog({
    required this.price,
    required this.product,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      iconColor: theme.colorScheme.onPrimary,
      icon: Icons.shopping_bag_outlined,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              _getTitle(),
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            _getText(),
            style: theme.textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            child: Text(
              tr("shopProductDetailsDialog.price", args: [price.toString()]),
              style: theme.textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          BaseDialogButtonsRow(
            confirmText: tr("shopProductDetailsDialog.buy"),
            cancelText: tr("close"),
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false)
          )
        ]
      ),
    );
  }

   String _getTitle() {
    switch(product) {
      case ShopProduct.randomNote:
        return tr("shopProductDetailsDialog.randomTitle");
      case ShopProduct.randomMonthNote:
        return tr("shopProductDetailsDialog.randomMonthTitle");
      case ShopProduct.note:
        return tr("shopProductDetailsDialog.noteTitle");
    }
  }

  String _getText() {
    switch(product) {
      case ShopProduct.randomNote:
        return tr("shopProductDetailsDialog.randomText");
      case ShopProduct.randomMonthNote:
        return tr("shopProductDetailsDialog.randomMonthText");
      case ShopProduct.note:
        return tr("shopProductDetailsDialog.noteText");
    }
  }

  static Future<bool?> show(
    BuildContext context,
    {
      required int price,
      required ShopProduct product,
    }
  ) {
    return BaseDialog.show<bool?>(
      context,
      label: "shop-product-details-dialog",
      dismissible: false,
      dialog: ShopProductDetailsDialog(
        price: price,
        product: product,
      )
    );
  }
}
