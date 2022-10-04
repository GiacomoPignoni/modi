import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Widget used to setup [EasyLocalization]
class Localization extends StatelessWidget {
  final Widget child;

  const Localization({
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: child
    );
  }
}
