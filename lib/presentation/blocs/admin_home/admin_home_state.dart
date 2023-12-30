part of 'admin_home_bloc.dart';

class AdminHomeState extends Equatable {
  final UserEntity userEntity;

  const AdminHomeState({
    this.userEntity = const UserEntity(
      userId: '',
      userType: '',
      userName: '',
      email: '',
      password: '',
    ),
  });

  AdminHomeState copyWith({
    UserEntity? userEntity,
  }) =>
      AdminHomeState(
        userEntity: userEntity ?? this.userEntity,
      );

  @override
  List<Object> get props => [userEntity];
}
