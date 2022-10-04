import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/base_information_dialog.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/user_service.dart';

enum ReadNotesPageView {
  me,
  partner
}

class ReadNotesPageController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final NotesService _notesSvc = GetIt.I.get<NotesService>();
  final UserService _userSvc = GetIt.I.get<UserService>();

  ModiUser? get currentUser => _userSvc.modiUser.value;

  final ValueNotifier<int> selectedYear = ValueNotifier(DateTime.now().year);
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<List<SingleNote>> notes = ValueNotifier([]);
  final ValueNotifier<Map<Mood, int>> moodsCount = ValueNotifier({});
  final ValueNotifier<ReadNotesPageView> selectedView = ValueNotifier(ReadNotesPageView.me);

  ReadNotesPageController() {
    notes.value = _notesSvc.getUnlocked(selectedYear.value);
    moodsCount.value = _notesSvc.getMoodsCount(selectedYear.value);
  }

  Future<void> changeYear(int? newYear) async {
    selectedYear.value = newYear ?? DateTime.now().year;
    _loadNotes();
  }

  void showInfoDialog() {
    BaseInformationDialog.show(
      _navigationSvc.currentContext,
      icon: Icons.info_outline_rounded,
      title: tr("readNotesPageInfoDialog.title"),
      text: tr("readNotesPageInfoDialog.text")
    );
  }

  void goBack() {
    _navigationSvc.pop();
  }

  void onSelectedViewChange(ReadNotesPageView? newView) {
    selectedView.value = newView ?? ReadNotesPageView.me;
    _loadNotes();
  }

  Future<void> reloadPartnerNotes() async {
    loading.value = true;
    notes.value = await _notesSvc.getPartnerNotesUnlocked(selectedYear.value, forceRealod: true);
    moodsCount.value = await _notesSvc.getPartnerMoodsCount(selectedYear.value);
    loading.value = false;
  }

  Future<void> _loadNotes() async {
    loading.value = true;
    switch(selectedView.value) {
      case ReadNotesPageView.me:
        await _notesSvc.preloadYearNotes(selectedYear.value);
        notes.value = _notesSvc.getUnlocked(selectedYear.value);
        moodsCount.value = _notesSvc.getMoodsCount(selectedYear.value);
        break;
      case ReadNotesPageView.partner:
        notes.value = await _notesSvc.getPartnerNotesUnlocked(selectedYear.value);
        moodsCount.value = await _notesSvc.getPartnerMoodsCount(selectedYear.value);
        break;
    }
    loading.value = false;
  }

  void dipose() {
    selectedYear.dispose();
    loading.dispose();
    notes.dispose();
    moodsCount.dispose();
    selectedView.dispose();
  }
}
