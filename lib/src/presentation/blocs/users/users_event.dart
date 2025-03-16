part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsersEvent extends UsersEvent {}

class UserTypeSelectEvent extends UsersEvent {
  final int value;
  final String name;

  const UserTypeSelectEvent({
    required this.value,
    required this.name,
  });
}
