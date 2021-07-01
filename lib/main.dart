import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'themes/dark_theme.dart';
import 'screens/main_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'CODEINE',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: MainScreen(),
    );
  }
}
