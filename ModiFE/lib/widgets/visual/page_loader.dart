import 'package:flutter/material.dart';
import 'package:modi/widgets/visual/spinner.dart';

class PageLoader extends StatelessWidget {
  final Widget child;
  final ValueNotifier<bool> loading;

  const PageLoader({
    required this.child,
    required this.loading,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);

    return Stack(
      children: [
        child,
        ValueListenableBuilder<bool>(
          valueListenable: loading,
          builder: (context, loading, child) {
            return Visibility(
              visible: loading,
              child: child!,
            );
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.shadowColor.withOpacity(0.3)
            ),
            child: const Spinner(),
          )
        ),
      ],
    );
  }
}
