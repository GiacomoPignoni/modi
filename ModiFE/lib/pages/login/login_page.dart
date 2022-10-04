import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/login/login_page_controller.dart';
import 'package:modi/theme/colors.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/animated/shake_widget.dart';
import 'package:modi/widgets/inputs/auth_social_button.dart';
import 'package:modi/widgets/inputs/button_text.dart';
import 'package:modi/widgets/inputs/text_with_link.dart';
import 'package:modi/widgets/visual/text_with_line_row.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/visual/logo_header.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/inputs/text_field.dart';

class LoginPage extends StatelessWidget {
  static const String routePath = "loginPage";

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<LoginPageController>(
      create: (_) => LoginPageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
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
                          controller: controller.emailCtrl,
                          disabledNotifier: controller.loading,
                          hint: tr("email"),
                          keyboardType: TextInputType.emailAddress,
                          icon: const Icon(Icons.email_outlined),
                          margin: const EdgeInsets.only(bottom: 30),
                          onSubmitted: (val) => controller.login(),
                        ),
                        ShakeWidget(
                          key: controller.passwordShakeKey,
                          shakeOffset: 2,
                          shakeCount: 2,
                          child: MyTextField(
                            controller: controller.passwordCtrl,
                            disabledNotifier: controller.loading,
                            hint: tr("password"),
                            obscureText: true,
                            icon: const Icon(Icons.lock_outline_rounded),
                            onSubmitted: (val) => controller.login(),
                          ),
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
                          padding: const EdgeInsets.only(top: 30),
                          child: Button(
                            loading: controller.loading,
                            onPressed: controller.login,
                            text: tr("loginPage.login"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonText(
                                text: tr("loginPage.forgotPassword"),
                                onPressed: controller.goToResetPassword,
                              ),
                            ],
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: TextWithLineRow(text: tr("loginPage.orLoginWith"))
                        ),
                        Row(
                          children: _getSocialButtons(controller)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: TextWithLink(
                            text: tr("loginPage.notHaveAccount") + " ",
                            linkText: tr("signUpPage.signUp"),
                            onPressed: controller.goToSignUp,
                          )
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

  List<Widget> _getSocialButtons(LoginPageController controller) {
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
