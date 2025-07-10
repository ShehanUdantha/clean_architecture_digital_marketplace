// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final BlocStatus status;
  final String authMessage;
  final String userType;

  const AuthState({
    this.user,
    this.status = BlocStatus.initial,
    this.authMessage = '',
    this.userType = '',
  });

  AuthState copyWith({
    ValueGetter<User?>? user,
    BlocStatus? status,
    String? authMessage,
    String? userType,
  }) {
    return AuthState(
      user: user != null ? user() : this.user,
      status: status ?? this.status,
      authMessage: authMessage ?? this.authMessage,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
        user,
        status,
        authMessage,
        userType,
      ];
}
