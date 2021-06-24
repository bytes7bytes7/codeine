import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/loading_circle.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/switch_button.dart';
import '../widgets/input_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/bloc.dart';
import '../constants.dart';
import '../global/next_page_route.dart';
import 'conditions_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final ValueNotifier<String> loginNotifier = ValueNotifier(null);
  final ValueNotifier<String> passwordNotifier = ValueNotifier(null);
  final ValueNotifier<String> codeNotifier = ValueNotifier(null);
  final ValueNotifier<bool> rememberNotifier = ValueNotifier(true);
  final PageController pageController = PageController();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    codeController.dispose();
    loginNotifier.dispose();
    passwordNotifier.dispose();
    codeNotifier.dispose();
    rememberNotifier.dispose();
    pageController.dispose();
    loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Bloc.authBloc.auth,
      initialData: AuthInitState(),
      builder: (context, snapshot) {
        if (snapshot.data is AuthInitState) {
          // pass
        } else if (snapshot.data is AuthLoadingState) {
          loading.value = true;
        } else if (snapshot.data is AuthDataState) {
          loading.value = false;
          AuthDataState state = snapshot.data;
          if (state.status == AuthStatus.needCode) {
            Bloc.authBloc.confirm();
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuad,
            );
          } else if (state.status == AuthStatus.loggedOut) {
            loginNotifier.value = '';
            passwordNotifier.value = '';
          } else if (state.status == AuthStatus.loggedIn) {
            // auth_bloc redirects on HomeScreen
          }
        } else if (snapshot.data == AuthErrorState) {
          loading.value = false;
          showInfoSnackBar(
            context,
            'Ошибка',
            Icons.error_outline_outlined,
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            gradient: RadialGradient(
              center: Alignment(-0.8, -1),
              radius: 1,
              colors: [
                Theme.of(context).splashColor,
                Theme.of(context).splashColor.withOpacity(0),
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
                      Spacer(flex: 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CODEINE',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                      Spacer(flex: 3),
                      Text(
                        'Вход',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 10),
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
                                SizedBox(height: 20),
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
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      NextPageRoute(
                                        nextPage: ConditionsScreen(),
                                      ),
                                    );
                                  },
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 34),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              if (!loading.value) {
                                if (pageController.page == 0) {
                                  if (loginController.text.isEmpty) {
                                    loginNotifier.value = 'Пустое поле';
                                  }
                                  if (passwordController.text.isEmpty) {
                                    passwordNotifier.value = 'Пустое поле';
                                  }
                                  if (loginController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    Bloc.authBloc.logIn(loginController.text,
                                        passwordController.text);
                                  }
                                } else {
                                  // TODO: implement it
                                  print('NOT IMPLEMENTED');
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              // TODO: make something more flexible

                              height: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .fontSize *
                                      2 +
                                  20,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: ValueListenableBuilder(
                                    valueListenable: loading,
                                    builder: (context, _, __) {
                                      if (loading.value) {
                                        return LoadingCircle();
                                      }
                                      return Text(
                                        'Войти',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .copyWith(fontSize: 22),
                                      );
                                    }),
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).splashColor,
                                    Theme.of(context)
                                        .splashColor
                                        .withOpacity(0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
