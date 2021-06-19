import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'themes/dark_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Codeine',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: LoginScreen(
      ),
    );
  }
}
