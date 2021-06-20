import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/user.dart';
import 'themes/dark_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // init singleton of user
    User();
    return MaterialApp(
      title: 'Codeine',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: SplashScreen(
      ),
    );
  }
}
