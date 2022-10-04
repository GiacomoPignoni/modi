import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:modi/pages/read-notes/read_notes_page_controller.dart';
import 'package:modi/widgets/inputs/double_selector.dart';
import 'package:provider/provider.dart';

class ReadNotesPageViewSelector extends StatelessWidget {
  const ReadNotesPageViewSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReadNotesPageController>(context);
  
    return Visibility(
      visible: controller.currentUser?.patnerNickname != null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DoubleSelector(
          firstOptionText: tr("me"),
          secondOptionText: controller.currentUser?.patnerNickname ?? "-",
          onChanged: (val) => controller.onSelectedViewChange(val ? ReadNotesPageView.partner : ReadNotesPageView.me)
        ),
      )
    );
  }
}
