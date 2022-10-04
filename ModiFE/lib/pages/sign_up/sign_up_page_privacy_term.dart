import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/sign_up/sign_up_page_controller.dart';
import 'package:provider/provider.dart';

class SignUpPagePrivacyTerm extends StatelessWidget {
  const SignUpPagePrivacyTerm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignUpPageController>(context);
    final theme = Theme.of(context);

    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: TextSpan(
        text: tr("signUpPage.bySignup"),
        style: theme.textTheme.bodyText2!.copyWith(
          fontSize: 11,
        ),
        children: [
          TextSpan(
            text: tr("termsAndConditions"),
            style: theme.textTheme.bodyText2!.copyWith(
              decoration: TextDecoration.underline,
              color: theme.colorScheme.primary,
              fontSize: 11
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = controller.openTermsAndConditionsPage
          ),
          TextSpan(
            text: tr("and"),
          ),
          TextSpan(
            text: tr("privacyPolicy"),
            style: theme.textTheme.bodyText2!.copyWith(
              decoration: TextDecoration.underline,
              color: theme.colorScheme.primary,
              fontSize: 11
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = controller.openPrivacyPolicyPage
          )
        ]
      )
    );
  }
}
