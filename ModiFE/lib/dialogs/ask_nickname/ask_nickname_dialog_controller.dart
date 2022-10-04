import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class AskNicknameDialogController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final UserService _userSvc = GetIt.I.get<UserService>();

  final TextEditingController nicknameCtrl = TextEditingController();

  final ValueNotifier<bool> showNicknameError = ValueNotifier(false);
  final ValueNotifier<bool> checkingNickname = ValueNotifier(false);

  Timer? _nicknameCheckTimer;

  void startTimer() {
    if(_nicknameCheckTimer != null) {
      _nicknameCheckTimer!.cancel();
    }

    _nicknameCheckTimer = Timer(const Duration(seconds: 1), () => _checkNickname());
  } 

  Future<void> _checkNickname() async {
    checkingNickname.value = true;

    if(nicknameCtrl.text.isNotEmpty) {
      final available = await _userSvc.checkNickname(nicknameCtrl.text);
      showNicknameError.value = available == false;
    } else {
      showNicknameError.value = false;
    }

    checkingNickname.value = false;
  }

  void confirm() {
    if(
      nicknameCtrl.text.isNotEmpty
      && checkingNickname.value == false
      && showNicknameError.value == false
    ) {
      _navigationSvc.pop(nicknameCtrl.text);
    }
  }

  void dispose() {
    nicknameCtrl.dispose();
    checkingNickname.dispose();
    showNicknameError.dispose();
    _nicknameCheckTimer?.cancel();
  }
}
