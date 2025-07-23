part of 'purchase_bloc.dart';

sealed class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class GetAllPurchaseHistory extends PurchaseEvent {}

class GetAllPurchaseItemsByItsProductIds extends PurchaseEvent {
  final PurchaseEntity purchaseDetails;

  const GetAllPurchaseItemsByItsProductIds({
    required this.purchaseDetails,
  });
}

class SetPurchaseStatusToDefault extends PurchaseEvent {}

class SetPurchaseProductsStatusToDefault extends PurchaseEvent {}
