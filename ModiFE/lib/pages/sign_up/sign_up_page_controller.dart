import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/pages/login/login_page.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';
import 'package:modi/utils/web_utils.dart';

class SignUpPageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final TextEditingController nicknameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> showNicknameError = ValueNotifier(false);
  final ValueNotifier<bool> checkingNickname = ValueNotifier(false);
  final ValueNotifier<String?> errorStr = ValueNotifier(null);

  Timer? _nicknameCheckTimer;
  
  Future<void> signUp() async {
    if(
      loading.value == false && checkingNickname.value == false
      && showNicknameError.value == false
      && nicknameCtrl.text.isNotEmpty
      && emailCtrl.text.isNotEmpty
      && passwordCtrl.text.isNotEmpty
    ) {
      loading.value = true;
      errorStr.value = null;

      final res = await _userSvc.signUp(nicknameCtrl.text, emailCtrl.text, passwordCtrl.text);
      if(res != null) {
        errorStr.value = res;
      }

      loading.value = false;
    }
  }

  Future<void> signUpWithGoogle() async {
    if(loading.value == false) {
      loading.value = true;
      await _userSvc.signInWithGoogle();
      loading.value = false;
    }
  }

  Future<void> signUpWithApple() async {
    if(loading.value == false) {
      loading.value = true;
      await _userSvc.signInWithApple();
      loading.value = false;
    }
  }

  void startTimer() {
    if(_nicknameCheckTimer != null) {
      _nicknameCheckTimer!.cancel();
    }

    _nicknameCheckTimer = Timer(const Duration(seconds: 1), () => _checkNickname());
  } 

  void goToLogin() {
    _navigationSvc.pushReplacementNamed(LoginPage.routePath);
  }

  void openTermsAndConditionsPage() {
    WebUtils.openTermsAndConditions();
  }

  void openPrivacyPolicyPage() {
    WebUtils.openPrivacyPolicy();
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

  void dispose() {
    nicknameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    loading.dispose();
    showNicknameError.dispose();
    checkingNickname.dispose();
    errorStr.dispose();
    _nicknameCheckTimer?.cancel();
  }
}
