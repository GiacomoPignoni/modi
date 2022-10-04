import 'package:flutter/material.dart';
import 'package:modi/theme/default_vars.dart';
import 'package:modi/widgets/inputs/button_icon.dart';
import 'package:modi/widgets/state_management/null_value_notifier_wrapper.dart';

class MyTextField extends StatefulWidget {
  final EdgeInsets margin;
  final String hint;
  final Icon? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final ValueNotifier<bool>? disabledNotifier;
  final bool disabled;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final ValueNotifier<bool>? loading;

  const MyTextField({
    required this.hint,
    this.disabledNotifier,
    this.obscureText = false,
    this.icon,
    this.keyboardType,
    this.margin = const EdgeInsets.all(0),
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.loading,
    this.disabled = false,
    Key? key
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final ValueNotifier<bool> showText = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          boxShadow: [ defaultShadow ]
        ),
        child: NullValueNotifierWrapper<bool>(
          defaultValue: false,
          listenable: widget.disabledNotifier,
          builder: (context, disabledFromNotifier) {
            return ValueListenableBuilder<bool>(
              valueListenable: showText,
              builder: (context, showTextVal, child) {
                return TextField(
                  enabled: !(disabledFromNotifier == true || widget.disabled == true),
                  controller: widget.controller,
                  obscureText: widget.obscureText && showTextVal == false,
                  keyboardType: widget.keyboardType,
                  textAlignVertical: (widget.icon == null) ? TextAlignVertical.top : TextAlignVertical.center,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    prefixIcon: widget.icon,
                    isCollapsed: true,
                    suffixIcon:  (widget.obscureText) 
                      ? ButtonIcon(
                        icon: (showText.value) ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        onPressed: () => showText.value = !showText.value,
                      )
                      : null,
                    suffix: NullValueNotifierWrapper<bool>(
                      listenable: widget.loading,
                      defaultValue: false,
                      builder: (context, loading) => Visibility(
                        visible: loading, 
                        child: const SizedBox(
                          width: 10, 
                          height: 10, 
                          child: CircularProgressIndicator.adaptive()
                        )
                      ),
                    )
                  )
                );
              }
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    showText.dispose();
    super.dispose();
  }
}
