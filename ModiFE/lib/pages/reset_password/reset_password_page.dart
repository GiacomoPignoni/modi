import 'package:flutter/material.dart';
import 'package:modi/pages/reset_password/reset_password_page_email_input.dart';
import 'package:modi/pages/reset_password/reset_password_page_email_sent.dart';
import 'package:modi/pages/reset_password/reset_password_page_controller.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class ResetPasswordPage extends StatelessWidget {
  static const String routePath = "reset-password";

  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<ResetPasswordPageController>(
      create: (_) => ResetPasswordPageController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 20,
            backgroundColor: theme.colorScheme.secondary,
            automaticallyImplyLeading: false
          ),
          body: SafeArea(
            child: PageView(
              controller: controller.pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ResetPasswordPageEmailInput(),
                ResetPasswordPageEmailSent()
              ],
            )
          ),
        );
      }
    );
  }
}
