import '../constants.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository._internal();

  static final _singleton = AuthRepository._internal();

  factory AuthRepository() {
    return _singleton;
  }

  Future<AuthStatus> logIn(String login, String password) async {
    return await AuthService.logInHttp(login, password);
  }

  Future<AuthStatus> getCode() async {
    return await AuthService.getCode();
  }

  Future<AuthStatus> confirmCode(String code) async {
    return await AuthService.confirmCode(code);
  }

  AuthStatus logOut() {
    return AuthService.logOut();
  }
}
