import 'package:flutter/material.dart';
import 'package:modi/pages/read-notes/read_notes_page_controller.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:provider/provider.dart';

class ReadNotesPageDropdownTitle extends StatelessWidget {
  const ReadNotesPageDropdownTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Provider.of<ReadNotesPageController>(context);

    return DropdownButton<int>(
      value: controller.selectedYear.value,
      borderRadius: defaultBorderRadius,
      items: [
        DropdownMenuItem(
          child: Text(
            "2022",
            style: theme.textTheme.headline3,
          ),
          value: 2022,
        )
      ],
      onChanged: controller.changeYear
    );
  }
}
