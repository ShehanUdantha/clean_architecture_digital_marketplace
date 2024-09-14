part of 'users_bloc.dart';

class UsersState extends Equatable {
  final BlocStatus status;
  final String message;
  final List<UserEntity> listOfUsers;

  const UsersState({
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfUsers = const [],
  });

  UsersState copyWith({
    BlocStatus? status,
    String? message,
    List<UserEntity>? listOfUsers,
  }) =>
      UsersState(
        status: status ?? this.status,
        message: message ?? this.message,
        listOfUsers: listOfUsers ?? this.listOfUsers,
      );

  @override
  List<Object> get props => [
        status,
        message,
        listOfUsers,
      ];
}
