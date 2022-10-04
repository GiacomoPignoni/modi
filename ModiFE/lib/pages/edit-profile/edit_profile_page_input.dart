import 'package:flutter/material.dart';
import 'package:modi/widgets/inputs/text_field.dart';

class EditProfilePageInput extends StatelessWidget {
  final String hint;
  final TextEditingController editionController;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double marginBottom;
  final void Function(String)? onSubmitted;
  final bool disabled;

  const EditProfilePageInput({
    required this.hint,
    required this.editionController,
    this.obscureText = false,
    this.keyboardType,
    this.onSubmitted,
    this.marginBottom = 20,
    this.disabled = false,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: theme.textTheme.headline6,
        ),
        MyTextField(
          hint: hint,
          controller: editionController,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onSubmitted: onSubmitted,
          margin: EdgeInsets.only(top: 5, bottom: marginBottom),
          disabled: disabled,
        )
      ],
    );
  }
}
