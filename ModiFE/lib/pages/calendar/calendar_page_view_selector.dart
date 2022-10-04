import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:modi/pages/calendar/calendar_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/double_selector.dart';
import 'package:provider/provider.dart';

class CalendarPageViewSelector extends StatelessWidget {
  const CalendarPageViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarPageController>(context);
  
    return Visibility(
      visible: controller.currentUser?.patnerNickname != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding, vertical: 10),
        child: DoubleSelector(
          firstOptionText: tr("me"),
          secondOptionText: controller.currentUser?.patnerNickname ?? "-",
          onChanged: (val) => controller.onSelectedViewChange(val ? CalendarPageView.partner : CalendarPageView.me),
        ),
      )
    );
  }
}
