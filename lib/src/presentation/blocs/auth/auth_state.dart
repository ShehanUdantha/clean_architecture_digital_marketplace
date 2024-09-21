// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final User? user;
  final BlocStatus status;
  final String userType;
  final BlocStatus signOutStatus;

  const AuthState({
    this.user,
    this.status = BlocStatus.initial,
    this.userType = '',
    this.signOutStatus = BlocStatus.initial,
  });

  @override
  List<Object> get props => [
        user!,
        status,
        userType,
        signOutStatus,
      ];
}

class InitialState extends AuthState {
  final BlocStatus statusValue;
  final User? userValue;
  final String userTypeValue;
  final BlocStatus signOutStatusValue;

  const InitialState({
    required this.statusValue,
    this.userValue,
    required this.userTypeValue,
    required this.signOutStatusValue,
  }) : super(
          status: statusValue,
          user: userValue,
          userType: userTypeValue,
          signOutStatus: signOutStatusValue,
        );
}

class LoadingState extends AuthState {
  final BlocStatus statusValue;

  const LoadingState({required this.statusValue}) : super(status: statusValue);
}

class AuthSuccessState extends AuthState {
  final User userValue;
  final BlocStatus statusValue;
  final String userTypeValue;

  const AuthSuccessState({
    required this.userValue,
    required this.statusValue,
    required this.userTypeValue,
  }) : super(
          user: userValue,
          status: statusValue,
          userType: userTypeValue,
        );
}

class AuthFailureState extends AuthState {
  final BlocStatus statusValue;
  const AuthFailureState({required this.statusValue})
      : super(status: statusValue);
}

class SignOutState extends AuthState {
  final BlocStatus signOutStatusValue;
  const SignOutState({required this.signOutStatusValue})
      : super(signOutStatus: signOutStatusValue);
}
