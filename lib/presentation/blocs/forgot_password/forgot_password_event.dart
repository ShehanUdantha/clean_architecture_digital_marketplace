part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendResetLinkButtonClickedEvent extends ForgotPasswordEvent {
  final String email;

  const SendResetLinkButtonClickedEvent({required this.email});
}

class SetForgotStatusToDefault extends ForgotPasswordEvent {}
