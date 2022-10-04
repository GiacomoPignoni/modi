import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/confirm_delete_dialog.dart';
import 'package:modi/dialogs/shop_page_info_dialog.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/models/moods.dart';
import 'package:modi/models/single_note.dart';
import 'package:modi/pages/calendar/calendar_page.dart';
import 'package:modi/services/message_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/user_service.dart';
import 'package:modi/widgets/animated/shake_widget.dart';

enum HomeOperation {
  view,
  creating,
  editing
}

class HomePageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NotesService _notesSvc = GetIt.I.get<NotesService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final MessageService _msgSvc = GetIt.I.get<MessageService>();

  final GlobalKey<ScaffoldState> _scaffolKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffolKey;

  ValueNotifier<ModiUser?> get modiUser => _userSvc.modiUser;

  final TextEditingController textCtrl = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  final ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());
  final ValueNotifier<Mood?> currentMood = ValueNotifier(null);
  final ValueNotifier<bool> showDeleteButton = ValueNotifier(false);
  final ValueNotifier<HomeOperation> currentOperation = ValueNotifier(HomeOperation.creating);
  final ValueNotifier<bool> operationLoading = ValueNotifier(false);

  final GlobalKey<ShakeWidgetState> buttonShakeKey = GlobalKey<ShakeWidgetState>();

  SingleNote? _currentNote;

  double? _panStartX;
  double? _currentPanX;

  HomePageController() {
    _setNoteData();
  }

  void drawerGoTo(String route) {
    _navigationSvc.pop();
    _navigationSvc.pushNamed(route);
  }

  void openDrawer() {
    _scaffolKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    _navigationSvc.pop();
  }

  Future<void> goToCalendarPage() async {
    final selectedDate = await _navigationSvc.pushNamed(CalendarPage.routePath) as DateTime?;

    if(selectedDate != null) {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));

      if(
        selectedDate.year == now.year && 
        !(selectedDate.month >= tomorrow.month && selectedDate.day >= tomorrow.day)
      ) {
        currentDate.value = selectedDate;
      } else {
        currentDate.value = now;
      }
      _setNoteData();
    }
  }

  void setNextDay() {
    final now = DateTime.now();
    if(!(currentDate.value.day == now.day && currentDate.value.month == now.month)) {
      currentDate.value = currentDate.value.add(const Duration(days: 1));
      _setNoteData();
    }
  }

  void setBackDay() {
    if(!(currentDate.value.month == 1 && currentDate.value.day == 1)) {
      currentDate.value = currentDate.value.add(const Duration(days: -1));
      _setNoteData();
    }
  }

  void selectMood(Mood mood) {
    if(currentOperation.value != HomeOperation.view) {
      currentMood.value = mood;
    }
  }

  void showConfirmDeleteDialog() {
    ConfirmDeleteDialog.show(
      _navigationSvc.currentContext,
      date: currentDate.value,
      onConfirm: _delete,
    );
  }

  void doOperation() {
    if(operationLoading.value == false) {
      if(currentOperation.value == HomeOperation.editing) {
        update();
      } else {
        submit();
      }
    }
  }

  void closeKeyboard() {
    textFocusNode.unfocus();
  }

  void showShopInfoDialog() {
    ShopPageInfoDialog.show(_navigationSvc.currentContext);
  }

  Future<void> submit() async {
    if(currentMood.value == null) {
      buttonShakeKey.currentState?.shake();
      _msgSvc.showSnackBar(type: MessageType.info, text: tr("homePage.haveToSelectMood"));
      return;
    }

    if(textCtrl.text.isEmpty) {
      buttonShakeKey.currentState?.shake();
      return;
    }

    operationLoading.value = true;
    closeKeyboard();

    final success = await _notesSvc.add(
      textCtrl.text,
      currentMood.value!, 
      currentDate.value
    );

    if(success) {
      _setNoteData();
    }
      
    operationLoading.value = false;
  }

  Future<void> update() async {
    if(_currentNote != null && textCtrl.text.isNotEmpty && currentMood.value != null) {
      operationLoading.value = true;
      closeKeyboard();

      final success = await _notesSvc.update(
        _currentNote!.id,
        textCtrl.text,
        currentMood.value!
      );

      if(success) {
        _setNoteData();
      }
      
      operationLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _userSvc.logout();
  }

  void onPanStart(DragStartDetails details) {
    _panStartX = details.globalPosition.dx;
  }

  void onPanUpdate(DragUpdateDetails details) {
    _currentPanX = details.globalPosition.dx;
  }

  void onPanEnd(DragEndDetails details) {
    if(_panStartX != null && _currentPanX != null) {
      final diff = _panStartX! - _currentPanX!;

      if(diff > 0) {
        setNextDay();
      } else {
        setBackDay();
      }
    }
  }

  Future<void> _delete() async {
    if(_currentNote != null && operationLoading.value == false) {
      operationLoading.value = true;
      closeKeyboard();

      final success = await _notesSvc.delete(_currentNote!.id);
      if(success) {
        _setNoteData();
      }

      operationLoading.value = false;
    }
  }

  Future<void> _setNoteData() async {
    final note = await _notesSvc.asyncGet(currentDate.value);

    if(note != null) {
      _currentNote = note;
      currentMood.value = note.mood;

      if(_isToday(note.date)) {
        currentOperation.value = HomeOperation.editing;
        textCtrl.text = note.text!;
      } else {
        currentOperation.value = HomeOperation.view;
        textCtrl.clear();
      }

      showDeleteButton.value = true;
    } else {
      _currentNote = null;
      currentMood.value = null;
      textCtrl.clear();
      showDeleteButton.value = false;
      currentOperation.value = HomeOperation.creating;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  void dispose() {
    textCtrl.dispose();
    textFocusNode.dispose();
    currentDate.dispose();
    currentMood.dispose();
    showDeleteButton.dispose();
    currentOperation.dispose();
    operationLoading.dispose();
  }
}
