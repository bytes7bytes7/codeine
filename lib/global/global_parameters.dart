import 'package:flutter/material.dart';

abstract class GlobalParameters{
  static final ValueNotifier<String> currentPage = ValueNotifier('SplashScreen');
}