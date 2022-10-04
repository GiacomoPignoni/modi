import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/dialogs/base_information_dialog.dart';
import 'package:modi/dialogs/send_partner_request/send_partner_request_dialog.dart';
import 'package:modi/dialogs/yes_or_no_dialog.dart';
import 'package:modi/models/modi_user.dart';
import 'package:modi/models/res/user_res.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/user_service.dart';

class PartnerPageController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final UserService _userSvc = GetIt.I.get<UserService>();

  ValueNotifier<ModiUser?> get modiUser => _userSvc.modiUser;

  final ValueNotifier<List<PartnerRequestDetails>?> requests = ValueNotifier(null);
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<int> miniLoading = ValueNotifier(-1);
  final ValueNotifier<bool> sendingNotification = ValueNotifier(false);

  PartnerPageController() {
    if(modiUser.value?.patnerNickname == null) {
      _loadRequests();
    }
  }

  void goBack() {
    if(loading.value == false) {
      _navigationSvc.pop();
    }
  }

  Future<void> acceptRequest(PartnerRequestDetails request, int nicknameIndex) async {
    if(miniLoading.value != nicknameIndex && loading.value == false) {
      loading.value = true;
      await _userSvc.acceptPartnerRequest(request.id);
      loading.value = false;
    }
  }

  void confirmRejectRequest(PartnerRequestDetails request, int nicknameIndex) {
    YesOrNotDialog.show(
      _navigationSvc.currentContext,
      title: tr("partnerPage.confirmRejectRequestTitle"),
      text: tr("partnerPage.confirmRejectRequestText", args: [request.nickname]),
    ).then((yes) {
      if(yes == true) {
        _rejectRequest(request, nicknameIndex);
      }
    });
  }

  void showSendPartnerRequestDialog() {
    SendPartnerRequestDialog.show(_navigationSvc.currentContext);
  }

  void showInfoDialog() {
    BaseInformationDialog.show(
      _navigationSvc.currentContext,
      icon: Icons.info_outline_rounded,
      title: tr("partnerPageInfoDialog.title"),
      text: tr("partnerPageInfoDialog.text"),
    );
  }

  void confirmRemovePartner() {
    YesOrNotDialog.show(
      _navigationSvc.currentContext,
      title: tr("partnerPage.confirmRemovePartnerTitle"),
      text: tr("partnerPage.confirmRemovePartnerText", args: [modiUser.value!.patnerNickname!]),
    ).then((yes) {
      if(yes == true) {
        _removePartner();
      }
    });
  }

  Future<void> sendPartnerNotification() async {
    sendingNotification.value = true;
    await _userSvc.sendPartnerNotification();
    sendingNotification.value = false;
  }

  Future<void> _loadRequests() async {
    requests.value = null;
    requests.value = await _userSvc.getPartnerRequestNicknames();
  }

  Future<void> _rejectRequest(PartnerRequestDetails request, int nicknameIndex) async {
    if(miniLoading.value != nicknameIndex && loading.value == false) {
      miniLoading.value = nicknameIndex;
      final success = await _userSvc.rejectPartnerRequest(request.id);
      if(success) {
        requests.value!.removeAt(nicknameIndex);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        requests.notifyListeners();
      }
      miniLoading.value = -1;
    }
  }

  Future<void> _removePartner() async {
    loading.value = true;
    await _userSvc.removePartner();
    loading.value = false;
    _loadRequests();
  }

  void dipose() {
    requests.dispose();
    loading.dispose();
    miniLoading.dispose();
    sendingNotification.dispose();
  }
}
