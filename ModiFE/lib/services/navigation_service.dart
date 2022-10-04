import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  dynamic get currentContext => _navigatorKey.currentContext;

  Future<T?> pushReplacementNamed<T>(String route) {
    return navigatorKey.currentState!.pushReplacementNamed(route);
  }

   Future<T?> pushNamedAndRemoveUntil<T>(String route) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
  }

  Future<T?> pushNamed<T>(String route, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(route, arguments: arguments);
  }

  void pop<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
}
