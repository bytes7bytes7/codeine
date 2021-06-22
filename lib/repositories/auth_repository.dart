import '../constants.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository._internal();
  static final _singleton = AuthRepository._internal();

  factory AuthRepository(){
    return _singleton;
  }

  Future<AuthStatus> logIn(String login, String password)async{
    return await AuthService.logIn(login, password);
  }

  Future<AuthStatus> confirm()async{
    return await AuthService.confirmationCode();
  }

  AuthStatus logOut(){
    return AuthService.logOut();
  }
}

