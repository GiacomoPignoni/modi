import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/info/info_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/inputs/button_text.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:modi/widgets/visual/page_title.dart';

class InfoPage extends StatelessWidget {
  static const routePath = "info";

  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<InfoPageController>(
      create: (_) => InfoPageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            leading: ButtonIcon(
              icon: Icons.chevron_left_rounded, 
              iconSize: 40,
              onPressed: controller.goBack,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child: Column(
              children: [
                PageTitle(
                  icon: Icons.info_outline_rounded,
                  title: tr("infoPage.title")
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: MyCard(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ButtonText(
                              text: tr("privacyPolicy"),
                              onPressed: controller.openPrivacyPolicyPage
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 20),
                              child: ButtonText(
                                text: tr("termsAndConditions"),
                                onPressed: controller.openTermsAndConditionsPage
                              ),
                            ),
                            Text(
                               tr("infoPage.developedBy"),
                               style: theme.textTheme.subtitle1,
                               textAlign: TextAlign.center
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: controller.version,
                    builder: (context, version, child) {
                      return Text(
                        tr("infoPage.version") + " ${version ?? ""}",
                        style: theme.textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      );
                    }
                  ),
                )
              ]
            ),
          ),
        );
      }
    );
  }
}
