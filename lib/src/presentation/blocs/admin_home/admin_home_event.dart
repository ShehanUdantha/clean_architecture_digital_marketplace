part of 'admin_home_bloc.dart';

sealed class AdminHomeEvent extends Equatable {
  const AdminHomeEvent();

  @override
  List<Object> get props => [];
}

class GetAdminDetailsEvent extends AdminHomeEvent {}

class SetAdminDetailsToDefault extends AdminHomeEvent {}
