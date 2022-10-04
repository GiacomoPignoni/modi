import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modi/pages/reset_password/reset_password_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/text_with_link.dart';
import 'package:modi/widgets/visual/logo_header.dart';
import 'package:provider/provider.dart';

class ResetPasswordPageEmailSent extends StatelessWidget {
  const ResetPasswordPageEmailSent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ResetPasswordPageController>(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        const LogoHeader(),
        Expanded(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: defaultScaffoldPadding,
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    tr("resetPasswordPage.checkYourEmail"),
                    style: theme.textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    tr("resetPasswordPage.emailSentText"),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SvgPicture(
                    controller.emailSvgProvider,
                    width: 100
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Button(
                    text: tr("resetPasswordPage.backToLogin"),
                    loading: controller.loading,
                    onPressed: controller.goBack
                  ),
                ),
                TextWithLink(
                  text: tr("resetPasswordPage.didNotReceiveEmail") + " ",
                  linkText: tr("resetPasswordPage.tryAnotherEmail"),
                  onPressed: controller.goToEmailInputStep,
                )
              ]
            )
          ),
        )
      ],
    );
  }
}
