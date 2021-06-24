import 'dart:async';

import '../global/global_parameters.dart';
import '../constants.dart';
import '../repositories/auth_repository.dart';

class AuthBloc {
  static final StreamController _authStreamController = StreamController<AuthState>.broadcast();
  static final AuthRepository _repository = AuthRepository();

  Stream<AuthState> get auth {
    return _authStreamController.stream;
  }

  static void dispose() {
    print('dispose AuthBloc');
    _authStreamController.close();
  }

  Future logIn(String login, String password) async {
    if (_authStreamController != null && !_authStreamController.isClosed) {
      _authStreamController.sink.add(AuthState._authLoading());
    }
    _repository.logIn(login, password).then((status) {
      if (status == AuthStatus.loggedIn) {
        GlobalParameters.currentPage.value = 'HomeScreen';
      } else if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authData(status));
    }).onError((error, stackTrace) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authError(error, stackTrace));
    });
  }

  Future confirm() async {
    if (_authStreamController != null && !_authStreamController.isClosed) {
      _authStreamController.sink.add(AuthState._authLoading());
    }
    _repository.confirm().then((status) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authData(status));
    }).onError((error, stackTrace) {
      if (!_authStreamController.isClosed)
        _authStreamController.sink.add(AuthState._authError(error, stackTrace));
    });
  }

  Future logOut() async {
    if (_authStreamController != null && !_authStreamController.isClosed) {
      _authStreamController.sink.add(AuthState._authLoading());
    }
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
