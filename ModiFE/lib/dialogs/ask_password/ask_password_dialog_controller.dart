import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class AskPasswordDialogController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final UserService _userSvc  = GetIt.I.get<UserService>();

  final TextEditingController passwordCtrl = TextEditingController();
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  Future<void> confirm() async {
    if(passwordCtrl.text.isNotEmpty) {
      loading.value = true;
      error.value = null;
      final result = await _userSvc.signInAgainForEdit(passwordCtrl.text);
      if(result == null) {
        _navigationSvc.pop(true);
      } else {
        error.value = result;
      }
      loading.value = false;
    }
  }

  void cancel() {
    if(loading.value == false) {
      _navigationSvc.pop(false);
    }
  }

  void dispose() {
    passwordCtrl.dispose();
  }
}
