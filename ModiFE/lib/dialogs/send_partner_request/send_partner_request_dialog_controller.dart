import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class SendParterRequestDialogController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final UserService _userSvc = GetIt.I.get<UserService>();

  final TextEditingController partnerNicknameCtrl = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<void> sendPartnerRequest() async {
    if(partnerNicknameCtrl.text.isNotEmpty) {
      errorMessage.value = null;
      loading.value = true;
      final result = await _userSvc.sendPartnerRequest(partnerNicknameCtrl.text);
      loading.value = false;
      if(result == null) {
        _navigationSvc.pop();
      } else {
        errorMessage.value = result;
      }
    }
  }

  void cancel() {
    if(loading.value == false) {
      _navigationSvc.pop();
    }
  }

  void dispose() {
    partnerNicknameCtrl.dispose();
    loading.dispose();
  }
}
