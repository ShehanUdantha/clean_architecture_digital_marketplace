// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'admin_home_bloc.dart';

sealed class AdminHomeEvent extends Equatable {
  const AdminHomeEvent();

  @override
  List<Object> get props => [];
}

class GetAdminDetailsEvent extends AdminHomeEvent {}

class SetAdminDetailsToDefault extends AdminHomeEvent {}

class UpdateYear extends AdminHomeEvent {
  final int year;

  const UpdateYear({required this.year});
}

class UpdateMonth extends AdminHomeEvent {
  final int month;

  const UpdateMonth({required this.month});
}

class GetMonthlyPurchaseStatus extends AdminHomeEvent {}

class GetMonthlyTotalBalance extends AdminHomeEvent {}

class GetMonthlyTotalBalancePercentage extends AdminHomeEvent {}

class GetMonthlyTopSellingProducts extends AdminHomeEvent {}
