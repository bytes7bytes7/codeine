part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoadEvent extends AuthEvent {}

class AuthLogInEvent extends AuthEvent {
  const AuthLogInEvent({
    required this.login,
    required this.password,
  });

  final String login;
  final String password;

  @override
  List<Object?> get props => [login, password];

  @override
  String toString() => 'AuthLogInEvent {login: $login, password: $password}';
}

class AuthLogOutEvent extends AuthEvent {}
