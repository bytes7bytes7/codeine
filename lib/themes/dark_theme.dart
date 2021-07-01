import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstantColors.scaffoldBackgroundColor,
  focusColor: ConstantColors.focusColor,
  disabledColor: ConstantColors.disabledColor,
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
      fontWeight: FontWeight.bold,
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
    bodyText2: TextStyle(
      fontSize: 18,
      color: ConstantColors.focusColor,
      fontWeight: FontWeight.normal,
    ),
    button: TextStyle(
      fontSize: 18,
      color: ConstantColors.splashColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);
