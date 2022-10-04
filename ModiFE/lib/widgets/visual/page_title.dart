import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? rightChild;

  const PageTitle({
    required this.icon,
    required this.title,
    this.rightChild,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: theme.textTheme.headline4!.color,
                size: 40
              ),
              Text(
                title,
                style: theme.textTheme.headline4
              ),
            ],
          ),
          rightChild ?? const SizedBox.shrink()
        ],
      )
    );
  }
}
