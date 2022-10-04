import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class EditProfilePageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController nicknameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  final ValueNotifier<bool> showPasswordError = ValueNotifier(false);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  bool get isFromSocial => _userSvc.isFromSocial;

  EditProfilePageController() {
    final modiUser = _userSvc.modiUser.value!;
    emailCtrl.text = _userSvc.userFirebaseEmail!;
    nicknameCtrl.text = modiUser.nickname;
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> save() async {
    if(_checkInputs()) {
      loading.value = true;

      // Check if nickname is updated
      if(nicknameCtrl.text != _userSvc.modiUser.value!.nickname) {
        final success = await _userSvc.updateNickname(nicknameCtrl.text);
        if(success == false) {
          nicknameCtrl.text = _userSvc.modiUser.value!.nickname;
          loading.value = false;
          return;
        }
      }

      // Check if email is updated
      if(emailCtrl.text != _userSvc.userFirebaseEmail) {
        final success = await _userSvc.updateEmail(emailCtrl.text);
        if(success == false) {
          emailCtrl.text = _userSvc.userFirebaseEmail!;
          loading.value = false;
          return;
        }
      }

      if(passwordCtrl.text.isNotEmpty) {
        await _userSvc.updatePassword(passwordCtrl.text);
      }

      loading.value = false;
    }
  }

  bool _checkInputs() {
    showPasswordError.value = false;
    if(passwordCtrl.text.isNotEmpty && passwordCtrl.text != confirmPasswordCtrl.text) {
      showPasswordError.value = true;
      return false;
    }

    if(emailCtrl.text.isEmpty || nicknameCtrl.text.isEmpty) {
      return false;
    }

    return true;
  }

  void goBack() {
    _navigationSvc.pop();
  }

  void dispose() {
    emailCtrl.dispose();
    nicknameCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    showPasswordError.dispose();
    loading.dispose();
  }
}
