import 'package:flutter/material.dart';

class NullValueNotifierWrapper<T> extends StatelessWidget {
  final T defaultValue;
  final ValueNotifier<T>? listenable;
  final Widget Function(BuildContext context, T value) builder;

  const NullValueNotifierWrapper({
    required this.defaultValue,
    required this.listenable,
    required this.builder,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(listenable != null) { 
      return ValueListenableBuilder<T>(
        valueListenable: listenable!,
        builder: (context, T value, child) => builder(context, value)
      );
    }
    
    return Builder(
      builder: (context) => builder(context, defaultValue),
    );
  }
}
