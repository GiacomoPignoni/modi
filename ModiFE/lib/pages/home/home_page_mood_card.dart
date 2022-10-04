import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/pages/home/home_page_controller.dart';
import 'package:modi/utils/mood_utils.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:provider/provider.dart';

class HomePageMoodCard extends StatelessWidget {
  const HomePageMoodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);

    return MyCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: DayRow(),
            ),
            ValueListenableBuilder<Mood?>(
              valueListenable: controller.currentMood,
              builder: (context, mood, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MoodButton(
                      mood: Mood.happy,
                      selected: mood == Mood.happy,
                      onPressed: () => controller.selectMood(Mood.happy)
                    ),
                    MoodButton(
                      mood: Mood.neutral,
                      selected: mood == Mood.neutral,
                      onPressed: () => controller.selectMood(Mood.neutral)
                    ),
                    MoodButton(
                      mood: Mood.sad,
                      selected: mood == Mood.sad,
                      onPressed: () => controller.selectMood(Mood.sad)
                    ),
                    MoodButton(
                      mood: Mood.angry,
                      selected: mood == Mood.angry,
                      onPressed: () => controller.selectMood(Mood.angry)
                    )
                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }
}

class DayRow extends StatelessWidget {
  const DayRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);
    final theme = Theme.of(context);

    return ValueListenableBuilder<DateTime>(
      valueListenable: controller.currentDate,
      builder: (context, currentDate, child)  {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ButtonIcon(
              icon: Icons.chevron_left_rounded,
              onPressed: controller.setBackDay
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "${currentDate.day} " + tr("months.${currentDate.month}"),
                style: theme.textTheme.headline2,
              )
            ),
            ButtonIcon(
              icon: Icons.chevron_right_rounded,
              onPressed: controller.setNextDay
            ),
          ],
        );
      }
    );
  }
}

class MoodButton extends StatelessWidget {
  final Mood mood;
  final bool selected;
  final void Function() onPressed;

  const MoodButton({
    required this.mood,
    required this.selected,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, anim) {
            final curvedAnimation = CurvedAnimation(
              parent: anim,
              curve: Curves.ease
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: child
            );
          },
          child: SvgPicture.asset(
            "assets/svg/${MoodUtils.getMoodFileName(mood, selected)}",
            key: ValueKey<String>(mood.toString() + selected.toString()),
            width: 50
          ),
        ),
      ),
    );
  }
}
