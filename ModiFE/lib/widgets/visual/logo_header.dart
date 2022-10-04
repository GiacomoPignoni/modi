import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        gradient: LinearGradient(
          tileMode: TileMode.clamp,
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.primary
          ]
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/modi_logo.svg",
          height: 120,
        ),
      )
    );
  }
}
