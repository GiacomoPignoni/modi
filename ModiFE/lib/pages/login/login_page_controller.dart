import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/pages/reset_password/reset_password_page.dart';
import 'package:modi/pages/sign_up/sign_up_page.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';
import 'package:modi/widgets/animated/shake_widget.dart';

class LoginPageController {
  final UserService _userSvc = GetIt.I.get<UserService>();
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final ValueNotifier<String?> errorStr = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);

  final GlobalKey<ShakeWidgetState> passwordShakeKey = GlobalKey<ShakeWidgetState>();

  Future<void> login() async {
    if(emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty && loading.value == false) {
      loading.value = true;
      errorStr.value = null;

      final res = await _userSvc.signInWithEmailAndPassword(emailCtrl.text, passwordCtrl.text);
      
      if(res != null) {
        errorStr.value = res;
        passwordShakeKey.currentState?.shake();
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
  
  void goToSignUp() {
    _navigationSvc.pushReplacementNamed(SignUpPage.routePath);
  }

  void goToResetPassword() {
    _navigationSvc.pushNamed(ResetPasswordPage.routePath);
  }

  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    errorStr.dispose();
    loading.dispose();
  }
}
