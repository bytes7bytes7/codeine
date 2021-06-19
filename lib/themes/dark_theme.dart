import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.scaffoldBackgroundColor,
  focusColor: ConstantColors.focusColor,
  accentColor: ConstantColors.accentColor,
  highlightColor: ConstantColors.highlightColor,
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
    subtitle1: TextStyle(
      fontSize: 16,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.normal,
    ),
  ),
);
