import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/pages/read-notes/read_notes_page_controller.dart';
import 'package:modi/utils/mood_utils.dart';
import 'package:modi/widgets/visual/card.dart';
import 'package:provider/provider.dart';

class ReadNotesPageMoodCard extends StatelessWidget {
  const ReadNotesPageMoodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReadNotesPageController>(context);

    return MyCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ValueListenableBuilder<Map<Mood, int>>(
        valueListenable: controller.moodsCount,
        builder: (context, moodsCount, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReadNotesPageMoodCardItem(
                mood: Mood.happy,
                number: moodsCount[Mood.happy] ?? 0,
              ),
              ReadNotesPageMoodCardItem(
                mood: Mood.neutral,
                number: moodsCount[Mood.neutral] ?? 0,
              ),
              ReadNotesPageMoodCardItem(
                mood: Mood.sad,
                number: moodsCount[Mood.sad] ?? 0,
              ),
              ReadNotesPageMoodCardItem(
                mood: Mood.angry,
                number: moodsCount[Mood.angry] ?? 0,
              )
            ],
          );
        }
      ),
    );
  }
}

class ReadNotesPageMoodCardItem extends StatelessWidget {
  final Mood mood;
  final int number;

  const ReadNotesPageMoodCardItem({
    required this.mood,
    required this.number,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          "assets/svg/${MoodUtils.getMoodFileName(mood, false)}",
          width: 50
        ),
        Text(
          number.toString()
        )
      ],
    );
  }
}
