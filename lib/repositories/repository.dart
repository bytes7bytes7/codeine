import 'auth_repository.dart';

abstract class Repository {
  static AuthRepository authRepository = AuthRepository();
}
