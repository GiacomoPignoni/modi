import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modi/theme/colors.dart';
import 'package:modi/theme/default_vars.dart';

final lightTheme = ThemeData(
  fontFamily: "Kodchasan",
  primaryColorLight: lightColor,
  primaryColorDark: textColor,
  shadowColor: shadowColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    primaryContainer: primaryColorVariant,
    onPrimary: lightColor,
    secondary: secondaryColor,
    secondaryContainer: secondaryColorVariant,
    background: backgroundColor,
    onSecondary: lightColor,
    error: dangerColor,
    onBackground: textColor,
    onError: lightColor,
    onSurface: textColor,
    surface: lightColor,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: lightColor,
      fontSize: 32,
      fontWeight: FontWeight.w600
    ),
    headline2: TextStyle(
      color: textColor,
      fontSize: 28,
      fontWeight: FontWeight.w500
    ),
    headline3: TextStyle(
      color: secondaryColor,
      fontSize: 25,
      fontWeight: FontWeight.w600
    ),
    headline4: TextStyle(
      color: primaryColor,
      fontSize: 32,
      fontWeight: FontWeight.w600
    ),
    headline5: TextStyle(
      color: secondaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),
    headline6: TextStyle(
      color: secondaryColor,
      fontSize: 18,
      fontWeight: FontWeight.normal
    ),
    bodyText1: TextStyle(
      color: lightColor,
      fontSize: 15,
      fontWeight: FontWeight.normal
    ),
    bodyText2: TextStyle(
      color: textColor,
      fontSize: 15,
      fontWeight: FontWeight.normal
    ),
    button: TextStyle(
      color: lightColor,
      fontSize: 18,
      fontWeight: FontWeight.w500
    ),
    subtitle1: TextStyle(
      color: textColor,
      fontSize: 13
    ),
    subtitle2:  TextStyle(
      color: dangerColor,
      fontSize: 13
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightColor,
    hintStyle: TextStyle(
      color: textColor.withAlpha(100),
      fontSize: 16
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: lightColor),
      borderRadius: defaultBorderRadius,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: lightColor),
      borderRadius: defaultBorderRadius,
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: lightColor),
      borderRadius: defaultBorderRadius,
    ),
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    color: lightColor,
  ),
  iconTheme: const IconThemeData(
    color: secondaryColor,
    size: 25,
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    backgroundColor: backgroundColor,
    iconTheme: IconThemeData(
      color: primaryColor
    )
  )
);
