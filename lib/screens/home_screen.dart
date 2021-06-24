import 'package:codeine/bloc/bloc.dart';
import 'package:codeine/global/global_parameters.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HOME',
              style: Theme.of(context).textTheme.headline2,
            ),
            TextButton(
              child: Text(
                'log out',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () {
                Bloc.authBloc.logOut();
                GlobalParameters.currentPage.value = 'LoginScreen';
              },
            ),
          ],
        ),
      ),
    );
  }
}
