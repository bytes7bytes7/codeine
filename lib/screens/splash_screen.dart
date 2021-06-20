import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).accentColor, Theme.of(context).highlightColor],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(
      body: Center(
        child: Text(
          'CODEINE',
          style: Theme.of(context).textTheme.headline1.copyWith(
                foreground: Paint()..shader = linearGradient,
              ),
        ),
      ),
    );
  }
}
