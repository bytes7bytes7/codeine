import 'package:codeine/widgets/show_info_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/switch_button.dart';
import '../widgets/input_field.dart';
import '../widgets/loading_circle.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/bloc.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final ValueNotifier<String> loginNotifier = ValueNotifier(null);
  final ValueNotifier<String> passwordNotifier = ValueNotifier(null);
  final ValueNotifier<String> codeNotifier = ValueNotifier(null);

  final ValueNotifier<bool> rememberNotifier = ValueNotifier(true);
  final PageController pageController = PageController();

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CODEINE',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                  Spacer(flex: 2),
                  Text(
                    'Вход',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: 10),
                  StreamBuilder(
                    stream: Bloc.authBloc.auth,
                    initialData: AuthInitState(),
                    builder: (context, snapshot) {
                      if (snapshot.data is AuthInitState) {
                        // pass
                      } else if (snapshot.data is AuthLoadingState) {
                        return LoadingCircle();
                      } else if (snapshot.data is AuthDataState) {
                        AuthDataState state = snapshot.data;
                        if (state.status == AuthStatus.needCode) {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuad,
                          );
                        } else if (state.status == AuthStatus.loggedOut) {
                          loginNotifier.value = '';
                          passwordNotifier.value = '';
                        }
                      } else {
                        showInfoSnackBar(
                          context,
                          'Ошибка',
                          Icons.error_outline_outlined,
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Expanded(
                    flex: 7,
                    child: PageView(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20),
                            InputField(
                              controller: loginController,
                              hint: 'Телефон',
                              errorNotifier: loginNotifier,
                            ),
                            SizedBox(height: 15),
                            InputField(
                              controller: passwordController,
                              hint: 'Пароль',
                              obscureText: true,
                              errorNotifier: passwordNotifier,
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 34),
                                SwitchButton(
                                  notifier: rememberNotifier,
                                ),
                                Text(
                                  'Запомнить',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            Spacer(flex: 1),
                            TextButton(
                              child: Text(
                                'Условия пользования',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            InputField(
                              controller: codeController,
                              hint: 'Код подтверждения',
                              errorNotifier: codeNotifier,
                            ),
                            Spacer(flex: 1),
                            TextButton(
                              child: Text(
                                'Выслать СМС',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        if (pageController.page == 0) {
                          if (loginController.text.isEmpty) {
                            loginNotifier.value = 'Пустое поле';
                          }
                          if (passwordController.text.isEmpty) {
                            passwordNotifier.value = 'Пустое поле';
                          }
                          if (loginController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            AuthStatus status = await Bloc.authBloc.logIn(
                                loginController.text, passwordController.text);
                          }
                        } else {
                          // TODO: implement it
                          print('NOT IMPLEMENTED');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 34),
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).accentColor,
                              Theme.of(context).accentColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
