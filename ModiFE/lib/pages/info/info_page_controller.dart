import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/utils/web_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoPageController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();

  final ValueNotifier<String?> version = ValueNotifier(null);

  InfoPageController() {
    _init();
  }

  Future<void> _init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  void openTermsAndConditionsPage() {
    WebUtils.openTermsAndConditions();
  }

  void openPrivacyPolicyPage() {
    WebUtils.openPrivacyPolicy();
  }

  void goBack() {
    _navigationSvc.pop();
  }

  void dispose() {
    version.dispose();
  }
}
