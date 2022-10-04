import 'package:flutter/material.dart';
import 'package:modi/theme/colors.dart';

class SnackBarContent extends StatelessWidget {
  final String text;

  const SnackBarContent({
    required this.text,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
  
  static SnackBar snackBar({
    required bool success,
    required String text,
  }) {
    return SnackBar(
      backgroundColor: (success) ? successColor.withOpacity(0.8) : null,
      content: SnackBarContent(
        text: text,
      ),
    );
  }
}
