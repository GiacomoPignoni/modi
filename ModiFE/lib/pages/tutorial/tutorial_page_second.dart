import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modi/theme/default_vars.dart';

class TutorialPageSecond extends StatelessWidget {
  const TutorialPageSecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr("tutorialPage.secondTitle"),
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              tr("tutorialPage.secondText"),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
