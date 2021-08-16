import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/show_captcha_dialog.dart';
import '../widgets/loading_circle.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/input_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/bloc.dart';
import '../constants.dart';
import '../global/next_page_route.dart';
import '../global/global_parameters.dart';
import 'conditions_screen.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController loginController;
  late TextEditingController passwordController;
  late TextEditingController codeController;
  late ValueNotifier<String> loginNotifier;
  late ValueNotifier<String> passwordNotifier;
  late ValueNotifier<String> codeNotifier;
  late PageController pageController;
  late ValueNotifier<bool> loading;
  late StreamSubscription<AuthState> subscription;

  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    codeController = TextEditingController();
    loginNotifier = ValueNotifier('');
    passwordNotifier = ValueNotifier('');
    codeNotifier = ValueNotifier('');
    pageController = PageController();
    loading = ValueNotifier(false);
    subscription = Bloc.authBloc.auth.listen((event) {
      if (event is AuthLoadingState) {
        loading.value = true;
      } else if (event is AuthDataState) {
        loading.value = false;
        AuthDataState state = event;
        if (state.status == AuthStatus.needCode) {
          loginNotifier.value = '';
          passwordNotifier.value = '';
          codeNotifier.value = '';
          Bloc.authBloc.getCode();
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutQuad,
          );
        } else if (state.status == AuthStatus.wrongCode) {
          codeNotifier.value = 'Неверно';
        } else if (state.status == AuthStatus.captcha) {
          showCaptchaDialog(context: context);
        } else if (state.status == AuthStatus.loggedOut) {
          loginNotifier.value = 'Неверно';
          passwordNotifier.value = 'Неверно';
        } else if (state.status == AuthStatus.loggedIn) {
          GlobalParameters.currentPage.value = 'HomeScreen';
        } else if (state.status == AuthStatus.noInternet) {
          showInfoSnackBar(
            context,
            'Нет интернета',
            Icons.wifi_off_outlined,
          );
        } else if (state.status == AuthStatus.ok) {
          // It means that verification code was got successfully
        }
      } else if (event is AuthErrorState) {
        loading.value = false;
        showInfoSnackBar(
          context,
          'Ошибка',
          Icons.error_outline_outlined,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        gradient: RadialGradient(
          center: const Alignment(-0.8, -1),
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
            center: const Alignment(-0.5, 1),
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
            resizeToAvoidBottomInset: true,
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CODEINE',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                    const Spacer(flex: 3),
                    Text(
                      'Вход',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      flex: 7,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              InputField(
                                controller: loginController,
                                hint: 'Телефон',
                                errorNotifier: loginNotifier,
                              ),
                              const SizedBox(height: 20),
                              InputField(
                                controller: passwordController,
                                hint: 'Пароль',
                                obscureText: true,
                                errorNotifier: passwordNotifier,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    onPressed: () async {
                                      AuthService.logOut();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.home_filled,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    onPressed: () async {
                                      GlobalParameters.currentPage.value =
                                          'HomeScreen';
                                    },
                                  ),
                                ],
                              ),
                              const Spacer(flex: 1),
                              TextButton(
                                child: Text(
                                  'Условия пользования',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    NextPageRoute(
                                      nextPage: const ConditionsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              InputField(
                                controller: codeController,
                                hint: 'Код подтверждения',
                                errorNotifier: codeNotifier,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.verified_outlined,
                                  color: Theme.of(context).focusColor,
                                ),
                                onPressed: () async {
                                  await AuthService.fetchUserData();
                                  var u = User();
                                  // ignore: avoid_print
                                  print(u);
                                },
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                child: Text(
                                  'Выслать СМС',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                onPressed: () {},
                              ),
                              const Spacer(flex: 1),
                              TextButton(
                                child: Text(
                                  'Отмена',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                onPressed: () {
                                  pageController.animateToPage(
                                    0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutQuad,
                                  );
                                },
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
                                if (codeController.text.isEmpty) {
                                  codeNotifier.value = 'Пустое поле';
                                } else {
                                  Bloc.authBloc
                                      .confirmCode(codeController.text);
                                }
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            // TODO: make something more flexible

                            height: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .fontSize! +
                                40,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: loading,
                                builder: (context, _, __) {
                                  if (loading.value) {
                                    return const LoadingCircle();
                                  }
                                  return Text(
                                    'Войти',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                            fontWeight: FontWeight.normal),
                                  );
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).splashColor,
                                  Theme.of(context).splashColor.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const       SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
