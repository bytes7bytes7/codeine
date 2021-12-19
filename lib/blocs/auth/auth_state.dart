part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {}

class AuthDataState extends AuthState {
  const AuthDataState(this.user);

  final User user;

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AuthDataState {user: $user}';
}

class AuthErrorState extends AuthState {
  const AuthErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AuthErrorState {error: $error}';
}
