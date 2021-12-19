import 'models/models.dart';

abstract class AuthRepository {
  Future<User> loadFromCache();

  Future<User> logIn(String login, String password);

  Future<User> logOut();

  Future<User> checkAuth();
}