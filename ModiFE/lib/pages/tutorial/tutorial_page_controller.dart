import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/pages/home/home_page.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notification_service.dart';

class TutorialPageController {
  final NavigationService _navigationSvc = GetIt.I.get<NavigationService>();
  final NotificationService _notificationSvc = GetIt.I.get<NotificationService>();

  final PageController pageController = PageController(initialPage: 0);

  final StreamController<int> _pageChangeStreamCtrl = StreamController.broadcast();
  Stream<int> get pageChange => _pageChangeStreamCtrl.stream;

  TutorialPageController() {
    pageController.addListener(_onPageChange);
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear
    );
  }

  void goToHome() {
    _navigationSvc.pushReplacementNamed(HomePage.routePath);
    _notificationSvc.checkPermission();
  }

  void _onPageChange() {
    _pageChangeStreamCtrl.add(pageController.page?.toInt() ?? 0);
  }

  void dispose() {
    pageController.removeListener(_onPageChange);
    pageController.dispose();
    _pageChangeStreamCtrl.close();
  }  
}
