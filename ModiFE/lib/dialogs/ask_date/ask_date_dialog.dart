import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modi/dialogs/ask_date/ask_date_dialog_controller.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';

class AskDateDialog extends StatelessWidget {
  final String title;
  final String text;

  const AskDateDialog({
    required this.title,
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return ProvideAndConsume<AskDateDialogController>(
      create: (_) => AskDateDialogController(),
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
              SizedBox(
                height: 120,
                child: CupertinoDatePicker(
                  initialDateTime: controller.selectedDateTime,
                  maximumDate: DateTime(now.year, 12, 31),
                  minimumDate: DateTime(now.year, 1, 1),
                  minimumYear: now.year,
                  maximumYear: now.year,
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: controller.onDateTimeChange,
                ),
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

  static Future<DateTime?> show(
    BuildContext context,
    {
      required String title,
      required String text,
    }
  ) {
    return BaseDialog.show<DateTime?>(
      context,
      label: "ask-date-dialog",
      dismissible: false,
      dialog: AskDateDialog(
        title: title,
        text: text
      )
    );
  }
}
