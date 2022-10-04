import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/utils/mood_utils.dart';
import 'package:modi/widgets/visual/card.dart';

class ReadNotesPageNoteCard extends StatelessWidget {
  final SingleNote note;

  const ReadNotesPageNoteCard({
    required this.note,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MyCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SvgPicture.asset(
                  "assets/svg/${MoodUtils.getMoodFileName(note.mood!, true)}",
                  width: 20,
                ),
              ),
              Text(
                "${tr("months.${note.date.month}")} ${note.date.day}, ${note.date.year}",
                style: theme.textTheme.bodyText2!.copyWith(fontSize: 18)
              )
            ],
          ),
          Divider(color: theme.colorScheme.onBackground),
          Flexible(
            child: Text(
              note.text!,
              textAlign: TextAlign.center
            )
          )
        ],
      ),
    );
  }
}
