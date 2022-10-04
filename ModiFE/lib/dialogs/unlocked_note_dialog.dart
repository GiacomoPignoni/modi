import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modi/dialogs/base_dialog.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/utils/mood_utils.dart';
import 'package:modi/widgets/inputs/button.dart';

class UnlockedNoteDialog extends StatelessWidget {
  final SingleNote note;

  const UnlockedNoteDialog({
    required this.note,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseDialog(
      icon: Icons.celebration_outlined,
      iconColor: theme.colorScheme.onPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr("unlockedNoteDialog.title"),
            style: theme.textTheme.headline3
          ),
          const Divider(color: Colors.transparent),
          Text(
           tr("unlockedNoteDialog.unlockedFrom"),
           textAlign: TextAlign.center,
          ),
          Text(
            tr("months.${note.date.month}") + " ${note.date.day}, ${note.date.year}",
            textAlign: TextAlign.center,
            style: theme.textTheme.headline5
          ),
          const Divider(color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
             tr("unlockedNoteDialog.youWere"),
             textAlign: TextAlign.center,
            ),
          ),
          SvgPicture.asset(
            "assets/svg/${MoodUtils.getMoodFileName(note.mood ?? Mood.neutral, true)}",
            width: 50
          ),
          const Divider(color: Colors.transparent),
          Text(
           tr("unlockedNoteDialog.andYouWritten"),
           textAlign: TextAlign.center,
          ),
          Text(
           note.text ?? "",
           textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Button(
              text: tr("close"),
              onPressed: () => Navigator.of(context).pop()
            ),
          )
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context,
    {
      required SingleNote note
    }
  ) {
    return BaseDialog.show<void>(
      context,
      label: "unlocked-note-dialog",
      dismissible: true,
      dialog: UnlockedNoteDialog(note: note)
    );
  }
}
