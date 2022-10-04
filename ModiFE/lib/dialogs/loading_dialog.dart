import 'package:flutter/material.dart';
import 'package:modi/widgets/visual/spinner.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Spinner(color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: "loading-dialog",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnimation = CurvedAnimation(
          parent: anim1,
          curve: Curves.ease
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) => const LoadingDialog()
    );
  }
}
