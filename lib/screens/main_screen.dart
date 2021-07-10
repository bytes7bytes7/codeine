import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../constants.dart';
import '../global/global_parameters.dart';

class MainScreen extends StatelessWidget {
  initSession() async {
    // init singleton of user
    User u = User();
    await u.init();

    AuthStatus status = await AuthService.checkCookie();
    switch(status){
      case AuthStatus.cookies:
        status = await AuthService.fetchUserData();
        switch(status){
          case AuthStatus.noInternet:
          case AuthStatus.loggedIn:
            GlobalParameters.currentPage.value = 'HomeScreen';
            break;
          case AuthStatus.loggedOut:
            GlobalParameters.currentPage.value = 'LoginScreen';
            break;
          case AuthStatus.unknownError:
            print('unknown error');
            GlobalParameters.currentPage.value = 'ErrorScreen';
            break;
          default:
            print('AuthStatus = $status');
            throw Exception('initSession error!!!');
        }
        break;
      case AuthStatus.noCookies:
        GlobalParameters.currentPage.value = 'LoginScreen';
        break;
      case AuthStatus.errorCookies:
        print('initSession errorCookies');
        GlobalParameters.currentPage.value = 'LoginScreen';
        break;
      case AuthStatus.noInternet:
        print('no Internet');
        GlobalParameters.currentPage.value = 'NoInternetScreen';
        break;
      case AuthStatus.unknownError:
        print('unknown error');
        GlobalParameters.currentPage.value = 'ErrorScreen';
        break;
      default:
        print('AuthStatus = $status');
        throw Exception('initSession error!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    initSession();
    return ValueListenableBuilder(
      valueListenable: GlobalParameters.currentPage,
      builder: (context, _, __) {
        return ConstantData.appDestinations[GlobalParameters.currentPage.value];
      },
    );
  }
}
