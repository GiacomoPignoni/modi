import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/pages/calendar/calendar_page_controller.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:provider/provider.dart';

class CalendarPageMonthGrid extends StatelessWidget {
  final int month;

  const CalendarPageMonthGrid({
    required this.month,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Provider.of<CalendarPageController>(context);
    
    final year = DateTime.now().year;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstDay = DateTime(year, month, 1);
    final daysOffeset = firstDay.weekday - 1;

    return MyCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              tr("months.$month"),
              style: theme.textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                7, 
                (index) => Text(
                  tr("shortDays.${index + 1}"),
                  style: theme.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                )
              )
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            padding: const EdgeInsets.all(0),
            children: List.generate(
              daysInMonth + daysOffeset, 
              (index) {
                if(index < daysOffeset) {
                  return const SizedBox.shrink();
                }

                final day = index + 1 - daysOffeset; 
                return CalendarPageMonthGridCell(
                  year: year,
                  month: month,
                  day: day,
                  color: controller.getNoteColor(year, month, day),
                  onPressed: () => controller.goBackWithSelectedDate(DateTime(year, month, day))
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarPageMonthGridCell extends StatelessWidget {
  final int year;
  final int month;
  final int day;
  final Color color;
  final void Function() onPressed;

  const CalendarPageMonthGridCell({
    required this.year, 
    required this.month,
    required this.day,
    required this.color,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.toString(),
            style: (_isToday()) 
              ? TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold
              ) 
              : null,
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color
            ),
          )
        ],
      ),
    );
  }

  bool _isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }
}
