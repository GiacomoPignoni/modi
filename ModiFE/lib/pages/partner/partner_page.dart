import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/pages/partner/partner_page_controller.dart';
import 'package:modi/pages/partner/partner_page_no_partner.dart';
import 'package:modi/pages/partner/partner_page_yes_partner.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/page_loader.dart';
import 'package:modi/widgets/visual/page_title.dart';

class PartnerPage extends StatelessWidget {
  static const String routePath = "partner";

  const PartnerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProvideAndConsume<PartnerPageController>(
      create: (_) => PartnerPageController(),
      dispose: (_, controller) => controller.dipose(),
      builder: (context, controller, child) {
        return PageLoader(
          loading: controller.loading,
          child: Scaffold(
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
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: defaultVerticalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight - 40,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          PageTitle(
                            icon: Icons.people_outline_rounded,
                            title: tr("partnerPage.title")
                          ),
                          Expanded(
                            child: ValueListenableBuilder<ModiUser?>(
                              valueListenable: controller.modiUser,
                              builder: (context, modiUser, child) {
                                if(modiUser!.patnerNickname == null) {
                                  return const PartnerPageNoPartner();
                                } else {
                                  return const PartnerPageYesPartner();
                                }
                              }
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            )
          ),
        );
      }
    );
  }
}
