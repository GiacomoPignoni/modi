import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProvideAndConsume<T> extends StatelessWidget {
  final T Function(BuildContext) create;
  final void Function(BuildContext, T)? dispose;
  final Widget Function(BuildContext, T, Widget?) builder;
  final Widget? child;

  const ProvideAndConsume({
    required this.create,
    required this.dispose,
    required this.builder,
    this.child,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      create: create,
      dispose: dispose,
      child: Consumer<T>(
        child: child,
        builder: builder,
      ),
    );
  }
}
