import 'package:flutter/material.dart';

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({Key? key}) : super(key: key);


  // TODO: finish this screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Text(
              'Условия\nпользования',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 1),
            TextButton(
              child: Text(
                'Назад',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
