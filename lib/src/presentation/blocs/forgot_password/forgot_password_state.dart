part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final BlocStatus status;
  final String authMessage;

  const ForgotPasswordState({
    this.email = '',
    this.status = BlocStatus.initial,
    this.authMessage = '',
  });

  ForgotPasswordState copyWith({
    String? email,
    BlocStatus? status,
    String? authMessage,
  }) =>
      ForgotPasswordState(
        email: email ?? this.email,
        status: status ?? this.status,
        authMessage: authMessage ?? this.authMessage,
      );

  @override
  List<Object> get props => [
        email,
        status,
        authMessage,
      ];
}
