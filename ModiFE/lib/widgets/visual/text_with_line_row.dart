import 'package:flutter/material.dart';

class TextWithLineRow extends StatelessWidget {
  final String text;

  const TextWithLineRow({
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(color: theme.colorScheme.onSurface)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 10
            ),
          ),
        ),
        Expanded(
          child: Divider(color: theme.colorScheme.onSurface)
        ),
      ],
    );
  }
}
