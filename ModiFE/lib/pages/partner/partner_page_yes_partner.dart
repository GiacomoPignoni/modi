import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/partner/partner_page_controller.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:provider/provider.dart';

class PartnerPageYesPartner extends StatelessWidget {
  const PartnerPageYesPartner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PartnerPageController>(context);
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: MyCard(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr("partnerPage.yourPartnerIs"),
                style: theme.textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FittedBox(
                  child: Text(
                    controller.modiUser.value!.patnerNickname!,
                    style: theme.textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    icon: Icons.notifications_none_rounded,
                    colorStyle: ButtonColorStyle.primary,
                    loading: controller.sendingNotification ,
                    onPressed: controller.sendPartnerNotification,
                  ),
                  Button(
                    icon: Icons.delete_outline_rounded,
                    colorStyle: ButtonColorStyle.danger,
                    onPressed: controller.confirmRemovePartner,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
