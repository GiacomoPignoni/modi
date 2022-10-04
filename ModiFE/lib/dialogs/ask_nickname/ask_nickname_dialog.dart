import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/ask_nickname/ask_nickname_dialog_controller.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/inputs/text_field.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class AskNicknameDialog extends StatelessWidget {
  const AskNicknameDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<AskNicknameDialogController>(
      create: (_) => AskNicknameDialogController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return BaseDialog(
          icon: Icons.info_outline_rounded,
          iconColor: theme.colorScheme.onPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tr("askNicknameDialog.title"),
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                tr("askNicknameDialog.text"),
                style: theme.textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              MyTextField(
                hint: tr("nickname"),
                controller: controller.nicknameCtrl,
                margin: const EdgeInsets.only(bottom: 5, top: 10),
                loading: controller.checkingNickname,
                onChanged: (_) => controller.startTimer(),
                onSubmitted: (_) => controller.confirm(),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: controller.showNicknameError,
                builder: (context, showNicknameError, child) {
                  return Visibility(
                    visible: showNicknameError,
                    child: Text(
                      tr("nicknameAlreadyUsed"),
                      style: theme.textTheme.subtitle2
                    )
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BaseDialogButtonsRow(
                  cancelText: tr("cancel"),
                  confirmText: tr("confirm"),
                  onConfirm: () => controller.confirm()
                ),
              )
            ],
          )
        );
      }
    );
  }
  
  static Future<String?> show(BuildContext context) {
    return BaseDialog.show<String>(
      context,
      label: "ask-nickname-dialog",
      dismissible: true,
      dialog: const AskNicknameDialog()
    );
  }
}
