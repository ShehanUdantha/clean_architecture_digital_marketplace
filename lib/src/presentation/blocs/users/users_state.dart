part of 'users_bloc.dart';

class UsersState extends Equatable {
  final BlocStatus status;
  final String message;
  final List<UserEntity> listOfUsers;
  final int currentUserType;
  final String currentUserTypeName;

  const UsersState({
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfUsers = const [],
    this.currentUserType = 0,
    this.currentUserTypeName = 'All Account',
  });

  UsersState copyWith({
    BlocStatus? status,
    String? message,
    List<UserEntity>? listOfUsers,
    int? currentUserType,
    String? currentUserTypeName,
  }) =>
      UsersState(
        status: status ?? this.status,
        message: message ?? this.message,
        listOfUsers: listOfUsers ?? this.listOfUsers,
        currentUserType: currentUserType ?? this.currentUserType,
        currentUserTypeName: currentUserTypeName ?? this.currentUserTypeName,
      );

  @override
  List<Object> get props => [
        status,
        message,
        listOfUsers,
        currentUserType,
        currentUserTypeName,
      ];
}
