import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'No Internet',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
