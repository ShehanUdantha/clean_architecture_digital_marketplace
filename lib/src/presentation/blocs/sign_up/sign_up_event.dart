part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpButtonClickedEvent extends SignUpEvent {
  final SignUpParams signUpParams;

  const SignUpButtonClickedEvent({required this.signUpParams});
}

class SendEmailButtonClickedEvent extends SignUpEvent {}

class SetSignUpStatusToDefault extends SignUpEvent {}
