import 'package:flutter/material.dart';

class ConditionsScreen extends StatelessWidget {

  // TODO: finish this screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Spacer(flex: 3),
            Text(
              'Условия\nпользования',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 1),
            TextButton(
              child: Text(
                'Назад',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
