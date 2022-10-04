import 'package:flutter/material.dart';
import 'package:modi/models/shop_product.dart';
import 'package:modi/pages/shop/shop_page_card.dart';
import 'package:modi/pages/shop/shop_page_controller.dart';
import 'package:modi/pages/shop/shop_page_title.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/page_loader.dart';

class ShopPage extends StatelessWidget {
  static const String routePath = "shop";

  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProvideAndConsume<ShopPageController>(
      create: (_) => ShopPageController(),
      dispose: (_, controller) => controller.dispose(), 
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            leading: ButtonIcon(
              icon: Icons.chevron_left_rounded,
              iconSize: 40,
              onPressed: controller.goBack,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ButtonIcon(
                  icon: Icons.info_outline_rounded,
                  onPressed: controller.showInfoDialog
                ),
              )
            ],
          ),
          body: PageLoader(
            loading: controller.loading,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultHorizontalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight - 40,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          const ShopPageTitle(),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShopPageCard(
                                  product: ShopProduct.randomNote,
                                  onPressed: controller.buyRandomNote
                                ),
                                const Divider(color: Colors.transparent),
                                ShopPageCard(
                                  product: ShopProduct.randomMonthNote,
                                  onPressed: controller.buyRandomMonthNote
                                ),
                                const Divider(color: Colors.transparent),
                                ShopPageCard(
                                  product: ShopProduct.note,
                                  onPressed: controller.buyNote
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        );
      }
    );
  }
}
