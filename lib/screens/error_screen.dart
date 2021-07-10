import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Unknown Error',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
