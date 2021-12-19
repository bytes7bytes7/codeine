import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:auth_repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthLoadingState()) {
    on<AuthLoadEvent>(_load);
    on<AuthLogInEvent>(_logIn);
    on<AuthLogOutEvent>(_logOut);
  }

  final AuthRepository _authRepository = VKAuthRepository.instance;

  void _load(AuthLoadEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthLoadingState) {
      emit(AuthLoadingState());
    }
    return emit.onEach<User>(
      _authRepository.checkAuth().asStream(),
      onData: (user) => emit(
        AuthDataState(user),
      ),
      onError: (Object error, StackTrace stackTrace) => emit(
        AuthErrorState('$error\n\n$stackTrace'),
      ),
    );
  }

  void _logIn(AuthLogInEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthLoadingState) {
      emit(AuthLoadingState());
      return emit.onEach<User>(
        _authRepository.logIn(event.login, event.password).asStream(),
        onData: (user) => emit(
          AuthDataState(user),
        ),
        onError: (Object error, StackTrace stackTrace) => emit(
          AuthErrorState('$error\n\n$stackTrace'),
        ),
      );
    }
  }

  void _logOut(AuthLogOutEvent event, Emitter<AuthState> emit) async {
    if (state is! AuthLoadingState) {
      emit(AuthLoadingState());
      return emit.onEach<User>(
        _authRepository.logOut().asStream(),
        onData: (user) => emit(
          AuthDataState(user),
        ),
        onError: (Object error, StackTrace stackTrace) => emit(
          AuthErrorState('$error\n\n$stackTrace'),
        ),
      );
    }
  }
}
