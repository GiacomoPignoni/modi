import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/sign_up/sign_up_page_controller.dart';
import 'package:modi/pages/sign_up/sign_up_page_privacy_term.dart';
import 'package:modi/theme/colors.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/auth_social_button.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/text_with_link.dart';
import 'package:modi/widgets/visual/logo_header.dart';
import 'package:modi/widgets/visual/text_with_line_row.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/inputs/text_field.dart';

class SignUpPage extends StatelessWidget {
  static const String routePath = "registration";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<SignUpPageController>(
      create: (_) => SignUpPageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (_, controller, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 20,
            backgroundColor: theme.colorScheme.secondary,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const LogoHeader(),
                Expanded(
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      padding: defaultScaffoldPadding,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        MyTextField(
                          controller: controller.nicknameCtrl,
                          disabledNotifier: controller.loading,
                          hint: tr("nickname"),
                          keyboardType: TextInputType.text,
                          icon: const Icon(Icons.person_outline),
                          loading: controller.checkingNickname,
                          onChanged: (newVal) => controller.startTimer(),
                          onSubmitted: (val) => controller.signUp(),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: controller.showNicknameError,
                          builder: (context, showNicknameError, child) {
                            return Visibility(
                              visible: showNicknameError,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  tr("nicknameAlreadyUsed"),
                                  style: TextStyle(
                                    color: theme.colorScheme.error
                                  ),
                                ),
                              )
                            );
                          }
                        ),
                        MyTextField(
                          controller: controller.emailCtrl,
                          disabledNotifier: controller.loading,
                          hint: tr("email"),
                          keyboardType: TextInputType.emailAddress,
                          icon: const Icon(Icons.email_outlined),
                          margin: const EdgeInsets.only(bottom: 20, top: 20),
                          onSubmitted: (val) => controller.signUp(),
                        ),
                        MyTextField(
                          controller: controller.passwordCtrl,
                          disabledNotifier: controller.loading,
                          hint: tr("password"),
                          obscureText: true,
                          icon: const Icon(Icons.lock_outline_rounded),
                          margin: const EdgeInsets.only(bottom: 20),
                          onSubmitted: (val) => controller.signUp(),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: controller.errorStr,
                          builder: (context, errorStr, child) {
                            if(errorStr == null) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                errorStr,
                                style: TextStyle(
                                  color: theme.colorScheme.error
                                ),
                              ),
                            );
                          }
                        ),
                        Button(
                          loading: controller.loading,
                          onPressed: controller.signUp,
                          text: tr("signUpPage.signUp"),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: SignUpPagePrivacyTerm(),
                        ),
                        TextWithLineRow(text: tr("signUpPage.orSignUpWith")),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _getSocialButtons(controller),
                          ),
                        ),
                        TextWithLink(
                          text: tr("signUpPage.alreadyHaveAnAccount") + " ",
                          linkText: tr("loginPage.login"),
                          onPressed: controller.goToLogin,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }

  List<Widget> _getSocialButtons(SignUpPageController controller) {
    final List<Widget> list = [];

    if(Platform.isIOS) {
      list.add(AuthSocialButton(
        color: googleColor,
        imgPath: "assets/png/google_logo.png",
        onPressed: controller.signUpWithGoogle
      ));

      list.add(const VerticalDivider(color: Colors.transparent));

      list.add(      
        AuthSocialButton(
          color: appleColor,
          imgPath: "assets/png/apple_logo.png",
          onPressed: controller.signUpWithApple
        )
      );
    } else {
      list.add(AuthSocialButton(
        color: googleColor,
        imgPath: "assets/png/google_logo.png",
        onPressed: controller.signUpWithGoogle,
        text: "Google",
      ));
    }

    return list;
  }
}
