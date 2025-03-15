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

class GetMonthlyPurchaseStatus extends AdminHomeEvent {
  final String userId;

  const GetMonthlyPurchaseStatus({
    required this.userId,
  });
}

class GetMonthlyTotalBalance extends AdminHomeEvent {
  final String userId;

  const GetMonthlyTotalBalance({
    required this.userId,
  });
}

class GetMonthlyTotalBalancePercentage extends AdminHomeEvent {
  final String userId;

  const GetMonthlyTotalBalancePercentage({
    required this.userId,
  });
}

class GetMonthlyTopSellingProducts extends AdminHomeEvent {
  final String userId;

  const GetMonthlyTopSellingProducts({
    required this.userId,
  });
}
