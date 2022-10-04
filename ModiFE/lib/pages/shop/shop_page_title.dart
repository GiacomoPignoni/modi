import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/pages/shop/shop_page_controller.dart';
import 'package:modi/widgets/visual/page_title.dart';
import 'package:provider/provider.dart';

class ShopPageTitle extends StatelessWidget {
  const ShopPageTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Provider.of<ShopPageController>(context);

    return PageTitle(
      icon: Icons.store_outlined,
      title: tr("shopPage.title"),
      rightChild: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on_outlined,
            size: 40
          ),
          ValueListenableBuilder<ModiUser?>(
            valueListenable: controller.modiUser,
            builder: (context, modiUser, child) {
              return Text(
                modiUser?.tokens.toString() ?? "0",
                style: theme.textTheme.headline3
              );
            }
          )
        ],
      ),
    );
  }
}
