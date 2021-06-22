import 'package:flutter/material.dart';

import '../widgets/switch_button.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneOfEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> rememberNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        gradient: RadialGradient(
          center: Alignment(-0.8, -1),
          radius: 1,
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).accentColor.withOpacity(0),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, 1),
            radius: 0.7,
            colors: [
              Theme.of(context).highlightColor,
              Theme.of(context).highlightColor.withOpacity(0),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CODEINE',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Вход',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    controller: phoneOfEmailController,
                    label: 'Телефон',
                  ),
                  SizedBox(height: 15),
                  InputField(
                    controller: passwordController,
                    label: 'Пароль',
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      SwitchButton(
                        notifier: rememberNotifier,
                      ),
                      Text(
                        'Запомнить',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'Условия пользования',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                          ),
                          onPressed: () {},
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              // TODO: implement
                            },
                            child: Container(
                              width: double.infinity,
                              height: 65,
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              child: Center(
                                child: Text(
                                  'Войти',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 22),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).accentColor,
                                    Theme.of(context)
                                        .accentColor
                                        .withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
