import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/models/shop_prices.dart';
import 'package:modi/models/shop_product.dart';
import 'package:modi/pages/shop/shop_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/visual/spinner.dart';
import 'package:provider/provider.dart';

class ShopPageCard extends StatelessWidget {
  final ShopProduct product;
  final void Function() onPressed;

  const ShopPageCard({
    required this.product,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ShopPageController>(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [ defaultShadow ],
          borderRadius: defaultBorderRadius,
          color: theme.primaryColorLight
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const ShopPageCardLeftIcon(),
              const VerticalDivider(color: Colors.transparent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(),
                        style: theme.textTheme.headline6
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          _getText(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ValueListenableBuilder<ShopPrices?>(
                        valueListenable: controller.prices,
                        builder: (context, prices, child) {
                          if(prices == null) {
                            return const SizedBox(
                              width: 15,
                              height: 15,
                              child: Spinner(),
                            );
                          }
    
                          return Text(
                            _getPrice(prices),
                            style: theme.textTheme.headline3
                          );
                        }
                      ) 
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch(product) {
      case ShopProduct.randomNote:
        return tr("shopPage.randomTitle");
      case ShopProduct.randomMonthNote:
        return tr("shopPage.randomMonthTitle");
      case ShopProduct.note:
        return tr("shopPage.noteTitle");
    }
  }

  String _getText() {
    switch(product) {
      case ShopProduct.randomNote:
        return tr("shopPage.randomText");
      case ShopProduct.randomMonthNote:
        return tr("shopPage.randomMonthText");
      case ShopProduct.note:
        return tr("shopPage.noteText");
    }
  }

  String _getPrice(ShopPrices prices) {
    switch(product) {
      case ShopProduct.randomNote:
        return tr("shopPage.price", args: [prices.randomNote.toString()]);
      case ShopProduct.randomMonthNote:
        return tr("shopPage.price", args: [prices.randomMonthNote.toString()]);
      case ShopProduct.note:
        return tr("shopPage.price", args: [prices.note.toString()]);
    }
  }
}

class ShopPageCardLeftIcon extends StatelessWidget {
  const ShopPageCardLeftIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        gradient: LinearGradient(
          tileMode: TileMode.clamp,
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.primary
          ]
        ),
      ),
      child: Icon(
        Icons.calendar_today_outlined,
        size: 50,
        color: theme.colorScheme.onPrimary
      ),
    );
  }
}
