import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  final Color? color;

  const Spinner({
    this.color,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
