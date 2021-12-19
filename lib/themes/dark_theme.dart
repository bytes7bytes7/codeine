import 'package:flutter/material.dart';

import '../constants/colors.dart' as constant_colors;

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: constant_colors.scaffoldBackgroundColor,
  focusColor: constant_colors.focusColor,
  disabledColor: constant_colors.disabledColor,
  splashColor: constant_colors.splashColor,
  highlightColor: constant_colors.highlightColor,
  errorColor: constant_colors.errorColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 46,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 28,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    headline3: TextStyle(
      fontSize: 21,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      fontSize: 18,
      color: constant_colors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    button: TextStyle(
      fontSize: 18,
      color: constant_colors.splashColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);
