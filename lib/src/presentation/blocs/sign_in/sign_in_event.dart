part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonClickedEvent extends SignInEvent {
  final SignInParams signInParams;

  const SignInButtonClickedEvent({required this.signInParams});
}

class CheckEmailVerificationEvent extends SignInEvent {}

class GetUserTypeEvent extends SignInEvent {}

class SetSignInStatusToDefault extends SignInEvent {}
