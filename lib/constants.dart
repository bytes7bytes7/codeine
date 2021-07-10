import 'package:codeine/screens/error_screen.dart';
import 'package:codeine/screens/no_internet_screen.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

abstract class ConstantColors {
  static const Color scaffoldBackgroundColor = Color(0xFF121421);
  static const Color focusColor = Color(0xFFEDEDED);
  static const Color disabledColor = Color(0xFFC5C5C5);
  static const Color splashColor = Color(0xFF7F2BCF);
  static const Color highlightColor = Color(0xFFB538A7);
  static const Color errorColor = Color(0xFFB53850);
}

abstract class ConstantData {
  // Do not add: MainScreen, ConditionsScreen
  static final Map<String, Widget> appDestinations = {
    'SplashScreen': SplashScreen(),
    'LoginScreen': LoginScreen(),
    'HomeScreen': HomeScreen(),
    'NoInternetScreen': NoInternetScreen(),
    'ErrorScreen' : ErrorScreen(),
  };
}

enum AuthStatus {
  ok,
  cookies,
  noCookies,
  errorCookies,
  loggedIn,
  needCode,
  captcha,
  wrongCode,
  loggedOut,
  noInternet,
  unknownError,
}

abstract class ConstantHTTP {
  static const String vkURL = 'https://vk.com/';
  static const String vkLoginURL = 'https://login.vk.com/';

  static const Map<String, String> headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'DNT': '1',
    'cookie':
        'remixusid=DELETED; remixflash=0.0.0; remixscreen_width=1920; remixscreen_height=1080; remixscreen_dpr=1; remixscreen_depth=24; remixscreen_orient=1; remixscreen_winzoom=1; remixseenads=0; remixlhk==DELETED; ',
    'Connection': 'keep-alive',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'ru-ru,ru;q=0.8,en-us;q=0.5,en;q=0.3',
  };
}

abstract class ConstantDBData {
  static const String databaseName = 'data.db';
  static const int databaseVersion = 1;

  //Names of tables
  static const String userTableName = 'user';

  // Special columns for user
  static const String id = 'id';
  static const String link = 'link';
  static const String name = 'name';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String shortName = 'shortName';
  static const String sex = 'sex';
  static const String photo = 'photo';
  static const String photo_100 = 'photo_100';
  static const String phoneOrEmail = 'phoneOrEmail';
}
