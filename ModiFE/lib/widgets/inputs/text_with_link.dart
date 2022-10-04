import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextWithLink extends StatefulWidget {
  final String text;
  final String linkText;
  final void Function() onPressed;

  const TextWithLink({
    required this.text,
    required this.linkText,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  State<TextWithLink> createState() => _TextWithLinkState();
}

class _TextWithLinkState extends State<TextWithLink> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150)
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final animation = ColorTween(
      begin: theme.colorScheme.primary,
      end: theme.colorScheme.primaryContainer
    ).animate(_controller);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return RichText(
          textAlign: TextAlign.center,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            text: widget.text,
            style: theme.textTheme.bodyText2,
            children: [
              TextSpan(
                text: widget.linkText,
                style: theme.textTheme.bodyText2!.copyWith(
                  color: animation.value
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onPressed
                  ..onTapDown = ((_) => _controller.forward())
                  ..onTapUp = ((_) => _controller.reverse())
                  ..onTapCancel = () => _controller.reverse()
              )
            ]
          )
        );
      }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
