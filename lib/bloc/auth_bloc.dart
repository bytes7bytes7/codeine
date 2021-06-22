import 'dart:async';

import '../constants.dart';
import '../repositories/auth_repository.dart';

class AuthBloc {
  AuthBloc(this._repository);

  final AuthRepository _repository;
  static StreamController _authStreamController;

  Stream<AuthState> get auth {
    if (_authStreamController == null || _authStreamController.isClosed)
      _authStreamController = StreamController<AuthState>.broadcast();
    return _authStreamController.stream;
  }

  void dispose() {
    _authStreamController.close();
  }

  Future logIn(String login, String password) async {
    _authStreamController.sink.add(AuthState._authLoading());
    _repository.logIn(login, password).then((status) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authData(status));
    }).onError((error, stackTrace) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authError(error, stackTrace));
    });
  }

  Future confirm() async {
    _authStreamController.sink.add(AuthState._authLoading());
    _repository.confirm().then((status) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authData(status));
    }).onError((error, stackTrace) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authError(error, stackTrace));
    });
  }

  Future logOut() async {
    _authStreamController.sink.add(AuthState._authLoading());
    AuthStatus status = _repository.logOut();
    if (!_authStreamController.isClosed)
      _authStreamController.sink.add(AuthState._authData(status));
  }
}

class AuthState {
  AuthState();

  factory AuthState._authData(AuthStatus auth) = AuthDataState;

  factory AuthState._authLoading() = AuthLoadingState;

  factory AuthState._authError(Error error, StackTrace stackTrace) =
      AuthErrorState;
}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  AuthErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class AuthDataState extends AuthState {
  AuthDataState(this.status);

  final AuthStatus status;
}
