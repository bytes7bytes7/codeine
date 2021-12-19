import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.focusColor,
                  ),
                ),
                hintText: 'Телефон/E-mail',
                hintStyle: theme.textTheme.subtitle1,
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: theme.focusColor,
                  ),
                ),
                hintText: 'Пароль',
                hintStyle: theme.textTheme.subtitle1,
              ),
            ),
            TextButton(
              child: const Text('Log In'),
              onPressed: () async {
                if (loginController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  authBloc.add(
                    AuthLogInEvent(
                      login: loginController.text,
                      password: passwordController.text,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
