import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userType;
  final String userName;
  final String email;
  final String password;

  const UserEntity({
    required this.userId,
    required this.userType,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        userId,
        userType,
        email,
        password,
      ];
}
