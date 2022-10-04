import 'package:flutter/material.dart';
import 'package:modi/theme/default_vars.dart';

class DoubleSelector extends StatefulWidget {
  final String firstOptionText;
  final String secondOptionText;
  final void Function(bool newValue) onChanged;
  final Duration animationDuration;
  final bool initialValue;

  const DoubleSelector({
    required this.firstOptionText,
    required this.secondOptionText,
    required this.onChanged,
    this.animationDuration = const Duration(milliseconds: 200),
    this.initialValue = false,
    Key? key
  }) : super(key: key);

  @override
  State<DoubleSelector> createState() => DoubleSelectorState();
}

class DoubleSelectorState extends State<DoubleSelector> {
  bool currentValue = false;

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [ defaultShadow ]
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: Curves.easeOutQuad,
                height: 30,
                left: (currentValue == false) ? 0 : constraints.maxWidth / 2,
                child: Container(
                  height: 30,
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                )
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _handleTap(false),
                      child: AnimatedDefaultTextStyle(
                        duration: widget.animationDuration,
                        style: (currentValue == false) ? theme.textTheme.bodyText2!.copyWith(color: theme.colorScheme.onPrimary) : theme.textTheme.bodyText2!,
                        child: Text(
                          widget.firstOptionText,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _handleTap(true),
                      child: AnimatedDefaultTextStyle(
                        duration: widget.animationDuration,
                        style: (currentValue == true) ? theme.textTheme.bodyText2!.copyWith(color: theme.colorScheme.onPrimary) : theme.textTheme.bodyText2!,
                        child: Text(
                          widget.secondOptionText,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ),
                  )
                ],
              )
            ]
          );
        }
      ),
    );
  }

  void _handleTap(bool newValue) {
    if(currentValue != newValue) {
      setState(() {
        currentValue = newValue;
      });
      widget.onChanged(newValue);
    }
  }

  void changeValue(bool newValue) {
    setState(() {
      currentValue = newValue;
    });
  }
}
