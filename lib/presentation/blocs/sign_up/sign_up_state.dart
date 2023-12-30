part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final SignUpParams signUpParams;
  final BlocStatus status;
  final String authMessage;

  const SignUpState({
    this.signUpParams = const SignUpParams(
      userName: '',
      email: '',
      password: '',
    ),
    this.status = BlocStatus.initial,
    this.authMessage = '',
  });

  SignUpState copyWith({
    SignUpParams? signUpParams,
    BlocStatus? status,
    String? authMessage,
  }) =>
      SignUpState(
        signUpParams: signUpParams ?? this.signUpParams,
        status: status ?? this.status,
        authMessage: authMessage ?? this.authMessage,
      );

  @override
  List<Object> get props => [
        signUpParams,
        status,
        authMessage,
      ];
}
