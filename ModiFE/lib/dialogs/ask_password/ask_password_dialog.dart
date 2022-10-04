import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/ask_password/ask_password_dialog_controller.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/text_field.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class AskPasswordDialog extends StatelessWidget {
  const AskPasswordDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<AskPasswordDialogController>(
      create: (_) => AskPasswordDialogController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return BaseDialog(
          icon: Icons.lock_rounded,
          iconColor: theme.colorScheme.onPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tr("askPasswordDialog.title"),
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                tr("askPasswordDialog.text"),
                style: theme.textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              MyTextField(
                hint: tr("password"),
                controller: controller.passwordCtrl,
                margin: const EdgeInsets.only(bottom: 5, top: 10),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onSubmitted: (_) => controller.confirm(),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: controller.error,
                builder: (context, error, child) {
                  return Visibility(
                    visible: error != null,
                    child: Text(
                      error ?? "",
                      style: theme.textTheme.subtitle2
                    )
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Button(
                        text: tr("cancel"),
                        onPressed: controller.cancel,
                        colorStyle: ButtonColorStyle.grey,
                      ),
                    ),
                    const VerticalDivider(color: Colors.transparent, width: 10),
                    Expanded(
                      child: Button(
                        text: tr("confirm"),
                        loading: controller.loading,
                        onPressed: controller.confirm
                      ),
                    )
                  ],
                )
              )
            ],
          )
        );
      }
    );
  }
  
  static Future<bool?> show(BuildContext context) {
    return BaseDialog.show<bool?>(
      context,
      label: "ask-password-dialog",
      dismissible: false,
      dialog: const AskPasswordDialog()
    );
  }
}
