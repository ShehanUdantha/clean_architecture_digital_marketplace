part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final SignInParams signInParams;
  final BlocStatus status;
  final String authMessage;
  final bool isVerify;
  final String userId;
  final String userType;

  const SignInState({
    this.signInParams = const SignInParams(
      email: '',
      password: '',
    ),
    this.status = BlocStatus.initial,
    this.authMessage = '',
    this.isVerify = false,
    this.userId = '',
    this.userType = '',
  });

  SignInState copyWith({
    SignInParams? signInParams,
    String? email,
    String? password,
    BlocStatus? status,
    String? authMessage,
    bool? isVerify,
    String? userId,
    String? userType,
  }) =>
      SignInState(
        signInParams: signInParams ?? this.signInParams,
        status: status ?? this.status,
        authMessage: authMessage ?? this.authMessage,
        isVerify: isVerify ?? this.isVerify,
        userId: userId ?? this.userId,
        userType: userType ?? this.userType,
      );

  @override
  List<Object> get props => [
        signInParams,
        status,
        authMessage,
        isVerify,
        userId,
        userType,
      ];
}
