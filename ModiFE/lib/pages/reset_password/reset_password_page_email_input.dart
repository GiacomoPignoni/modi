import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/reset_password/reset_password_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/text_field.dart';
import 'package:modi/widgets/inputs/text_with_link.dart';
import 'package:modi/widgets/visual/logo_header.dart';
import 'package:provider/provider.dart';

class ResetPasswordPageEmailInput extends StatelessWidget {
  const ResetPasswordPageEmailInput({Key? key}) : super(key: key);

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
                    tr("resetPasswordPage.resetPassword"),
                    style: theme.textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    tr("resetPasswordPage.enterEmailText"),
                    textAlign: TextAlign.center,
                  ),
                ),
                MyTextField(
                  hint: "Email",
                  icon: const Icon(Icons.email_outlined),
                  controller: controller.emailCtrl,
                  disabledNotifier: controller.loading,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (val) => controller.sendPasswordResetEmail(),
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: controller.errorStr,
                  builder: (context, errorStr, child) {
                    if(errorStr == null) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        errorStr,
                        style: TextStyle(
                          color: theme.colorScheme.error
                        ),
                      ),
                    );
                  }
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Button(
                    text: tr("confirm"),
                    loading: controller.loading,
                    onPressed: controller.sendPasswordResetEmail,
                  ),
                ),
                TextWithLink(
                  text: tr("resetPasswordPage.rememberPassword") + " ",
                  linkText: tr("loginPage.login"),
                  onPressed: controller.goBack,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
