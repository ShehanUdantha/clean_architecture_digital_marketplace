part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckUserAuthEvent extends AuthEvent {
  final User? user;

  const CheckUserAuthEvent({required this.user});
}

class SignOutEvent extends AuthEvent {}

class RefreshUserEvent extends AuthEvent {}

class SetAuthStatusToDefault extends AuthEvent {}
