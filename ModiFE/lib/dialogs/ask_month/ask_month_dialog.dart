import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/ask_month/ask_month_dialog_controller.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class AskMonthDialog extends StatelessWidget {
  final String title;
  final String text;
  final String hint;

  const AskMonthDialog({
    required this.title,
    required this.text,
    required this.hint,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProvideAndConsume<AskMonthDialogController>(
      create: (_) => AskMonthDialogController(),
      dispose: (_, controller) => controller.dispose(),
      builder: (context, controller, child) {
        return BaseDialog(
          icon: Icons.calendar_today_outlined,
          iconColor: theme.colorScheme.onPrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.headline2
              ),
              Text(
                text,
                style: theme.textTheme.bodyText2
              ),
              ValueListenableBuilder<int?>(
                valueListenable: controller.selectedMonth,
                builder: (context, selectedMonth, child) {
                  return DropdownButton(
                    borderRadius: defaultBorderRadius,
                    value: selectedMonth,
                    onChanged: controller.onSelectedMonthChange,
                    hint: Text(
                      hint,
                      style: theme.textTheme.bodyText2
                    ),
                    items: controller.monthNums.map<DropdownMenuItem<int>>((monthN) {
                      return DropdownMenuItem<int>(
                        value: monthN,
                        child: Text(
                          tr("months.$monthN"),
                          style: theme.textTheme.bodyText2
                        )
                      );
                    }).toList(),
                  );
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BaseDialogButtonsRow(
                  cancelText: tr("cancel"),
                  confirmText: tr("confirm"),
                  onCancel: () => controller.cancel(),
                  onConfirm: () => controller.confirm()
                ),
              )
            ],
          )
        );
      }
    );
  }

  static Future<int?> show(
    BuildContext context,
    {
      required String title,
      required String text,
      required String hint
    }
  ) {
    return BaseDialog.show<int?>(
      context,
      label: "ask-number-dialog",
      dismissible: false,
      dialog: AskMonthDialog(
        title: title,
        text: text,
        hint: hint
      )
    );
  }
}
