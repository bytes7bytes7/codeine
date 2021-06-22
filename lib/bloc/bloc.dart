import '../bloc/auth_bloc.dart';
import '../repositories/repository.dart';

abstract class Bloc {
  static AuthBloc _authBloc;

  static AuthBloc get authBloc {
    if (_authBloc != null) return _authBloc;
    _authBloc = AuthBloc(Repository.authRepository);
    return _authBloc;
  }
}
