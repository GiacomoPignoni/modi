import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/services/ad_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/user_service.dart';
import 'package:modi/theme/colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum CalendarPageView {
  me,
  partner
}

class CalendarPageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NotesService _notesSvc = GetIt.I.get<NotesService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final AdService _adSvc = GetIt.I.get<AdService>();

  ModiUser? get currentUser => _userSvc.modiUser.value;

  final ValueNotifier<CalendarPageView> selectedView = ValueNotifier(CalendarPageView.me);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  final ItemScrollController itemsScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Future<BannerAd> get bannerAd {
    return _adSvc.getBannerAd();
  }

  CalendarPageController() {
    itemPositionsListener.itemPositions.addListener(_jumpToCurrentMonth);
  }

  Color getNoteColor(int year, int month, int day) {
    late final SingleNote? note;
    switch(selectedView.value) {
      case CalendarPageView.me:
        note = _notesSvc.get(DateTime(year, month, day));
        break;
      case CalendarPageView.partner:
        note = _notesSvc.getPartnerNote(DateTime(year, month, day));
        break;
    }

    if(note != null) {
      return moodsColor[note.mood] ?? Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  Future<void> onSelectedViewChange(CalendarPageView? newView) async {
    if(newView == CalendarPageView.partner) {
      loading.value = true;
      await _notesSvc.preloadPartnerYearNotes(DateTime.now().year);
      loading.value = false;
    }
    selectedView.value = newView ?? CalendarPageView.me;
  }

  void goBackWithSelectedDate(DateTime date) {
    _navigationSvc.pop(date);
  }

  void goBack() {
    _navigationSvc.pop();
  }

  Future<void> reloadPartnerNotes() async {
    loading.value = true;
    await _notesSvc.preloadPartnerYearNotes(DateTime.now().year, forceRealod: true);
    // Necessary to rebuild all the month grids so they will take the new data
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    selectedView.notifyListeners();
    loading.value = false;
  }

  void _jumpToCurrentMonth() {
    itemsScrollController.jumpTo(index: DateTime.now().month - 1);
    itemPositionsListener.itemPositions.removeListener(_jumpToCurrentMonth);
  }
  
  void dipose() {
    selectedView.dispose();
    loading.dispose();
  }
}
