import 'package:flutter/material.dart';
import 'package:modi/theme/default_vars.dart';

/// Small colored button with an image inside
/// 
/// Used to show social logos for login or signup pages
class AuthSocialButton extends StatefulWidget {
  /// Button color
  /// 
  /// Automaticclly generate a gradient with a darker color
  final Color color;

  /// Image to show inside the button
  /// 
  /// The color of the image can't be changed, so pay attention about the button color and image color
  final String imgPath;

  /// Text to show insde the button before the icon
  /// 
  /// If is null it will not be show
  final String? text;

  final void Function() onPressed;

  const AuthSocialButton({
    required this.color,
    required this.imgPath,
    required this.onPressed,
    this.text,
    Key? key
  }) : super(key: key);

  @override
  State<AuthSocialButton> createState() => _AuthSocialButtonState();
}

class _AuthSocialButtonState extends State<AuthSocialButton> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    final hlsColor = HSLColor.fromColor(widget.color);
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => isDown = true),
        onTapUp: (_) => setState(() => isDown = false),
        onTapCancel: () => setState(() => isDown = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.ease,
          alignment: Alignment.center,
          height: 45,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              tileMode: TileMode.clamp,
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                widget.color,
                hlsColor.withLightness(hlsColor.lightness - 0.1).toColor()
              ]
            ),
            boxShadow: (isDown) ? null : const [ defaultShadow ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imgPath,
                width: 20,
              ),
              Visibility(
                visible: widget.text != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.text ?? "",
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary
                    )
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}
