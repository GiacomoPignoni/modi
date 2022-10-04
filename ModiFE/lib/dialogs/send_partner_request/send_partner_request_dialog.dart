import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/send_partner_request/send_partner_request_dialog_controller.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/button.dart';
import 'package:modi/widgets/inputs/text_field.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class SendPartnerRequestDialog extends StatelessWidget {
  const SendPartnerRequestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<SendParterRequestDialogController>(
      create: (_) => SendParterRequestDialogController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return BaseDialog(
          icon: Icons.people_outline_rounded,
          iconColor: theme.colorScheme.onPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tr("sendPartnerRequestDialog.title"),
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                tr("sendPartnerRequestDialog.text"),
                style: theme.textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              MyTextField(
                hint: tr("sendPartnerRequestDialog.partnerNickname"),
                controller: controller.partnerNicknameCtrl,
                margin: const EdgeInsets.only(top: 10),
                disabledNotifier: controller.loading
              ),
              ValueListenableBuilder<String?>(
                valueListenable: controller.errorMessage,
                builder: (context, errorMessage, child) {
                  return Visibility(
                    visible: errorMessage != null,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5),
                      child: Text(
                        errorMessage ?? "",
                        style: theme.textTheme.subtitle2,
                      ),
                    ),
                  );
                }
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
                        text: tr("sendPartnerRequestDialog.send"),
                        loading: controller.loading,
                        onPressed: controller.sendPartnerRequest
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        );
      }
    );
  }

  static Future<void> show(BuildContext context) {
    return BaseDialog.show<void>(
      context,
      label: "send-partner-request-dialog",
      dismissible: false,
      dialog: const SendPartnerRequestDialog()
    );
  }
}
