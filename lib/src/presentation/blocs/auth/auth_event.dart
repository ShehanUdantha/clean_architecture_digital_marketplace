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

class SignUpButtonClickedEvent extends AuthEvent {
  final SignUpParams signUpParams;

  const SignUpButtonClickedEvent({required this.signUpParams});
}

class SendEmailButtonClickedEvent extends AuthEvent {}

class SignInButtonClickedEvent extends AuthEvent {
  final SignInParams signInParams;

  const SignInButtonClickedEvent({required this.signInParams});
}

class GetUserTypeEvent extends AuthEvent {
  final String uid;

  const GetUserTypeEvent({required this.uid});
}

class SignOutEvent extends AuthEvent {}

class SendResetLinkButtonClickedEvent extends AuthEvent {
  final String email;

  const SendResetLinkButtonClickedEvent({required this.email});
}

class SetAuthStatusToDefault extends AuthEvent {}
