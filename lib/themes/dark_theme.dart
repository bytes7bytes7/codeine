import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.scaffoldBackgroundColor,
  focusColor: ConstantColors.focusColor,
  splashColor: ConstantColors.splashColor,
  highlightColor: ConstantColors.highlightColor,
  errorColor: ConstantColors.errorColor,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 46,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 28,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    headline3: TextStyle(
      fontSize: 23,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);
