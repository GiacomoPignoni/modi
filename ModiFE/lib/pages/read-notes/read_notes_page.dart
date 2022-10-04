import 'package:flutter/material.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/pages/read-notes/read_notes_page_dropdown_title.dart';
import 'package:modi/pages/read-notes/read_notes_page_controller.dart';
import 'package:modi/pages/read-notes/read_notes_page_mood_card.dart';
import 'package:modi/pages/read-notes/read_notes_page_note_card.dart';
import 'package:modi/pages/read-notes/read_notes_page_view_selector.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/provide_and_consume.dart';
import 'package:modi/widgets/visual/page_loader.dart';

class ReadNotesPage extends StatelessWidget {
  static const String routePath = "read-notes";

  const ReadNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProvideAndConsume<ReadNotesPageController>(
      create: (_) => ReadNotesPageController(),
      dispose: (_, controller) => controller.dipose(),
      builder: (context, controller, child) {
        return Scaffold(
          appBar: _getAppBar(controller),
          body: PageLoader(
            loading: controller.loading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
              child: Column(
                children: [
                  const ReadNotesPageViewSelector(),
                  const ReadNotesPageMoodCard(),
                  ValueListenableBuilder<List<SingleNote>>(
                    valueListenable: controller.notes,
                    builder: (context, notes, child) {
                      return Expanded(
                        child: ListView.separated(
                          itemCount: notes.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          itemBuilder: (context, index) {
                            return ReadNotesPageNoteCard(
                              note: notes[index]
                            );
                          },
                          separatorBuilder: (context, i) => const Divider(color: Colors.transparent)
                        )
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  PreferredSizeWidget _getAppBar(ReadNotesPageController controller) {
    return AppBar(
      centerTitle: true,
      title: const ReadNotesPageDropdownTitle(),
      leading: ButtonIcon(
        icon: Icons.chevron_left_rounded, 
        iconSize: 40,
        onPressed: controller.goBack
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ValueListenableBuilder<ReadNotesPageView>(
            valueListenable: controller.selectedView,
            builder: (context, selectedView, child) {
              return Visibility(
                visible: selectedView == ReadNotesPageView.partner,
                child: child!
              );
            },
            child: ButtonIcon(
              icon: Icons.replay_rounded,
              onPressed: controller.reloadPartnerNotes
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ButtonIcon(
            icon: Icons.info_outline_rounded,
            onPressed: controller.showInfoDialog
          ),
        ),
      ],
    );
  }
}
