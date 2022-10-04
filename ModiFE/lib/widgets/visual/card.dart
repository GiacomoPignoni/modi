import 'package:flutter/material.dart';
import 'package:modi/theme/default_vars.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const MyCard({
    required this.child,
    this.padding,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: const [ defaultShadow ],
        color: theme.primaryColorLight,
        borderRadius: defaultBorderRadius
      ),
      child: child,
    );
  }
}
