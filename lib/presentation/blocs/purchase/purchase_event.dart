part of 'purchase_bloc.dart';

sealed class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class GetAllPurchaseHistory extends PurchaseEvent {}

class GetAllPurchaseItemsByDate extends PurchaseEvent {
  final List<String> productIds;

  const GetAllPurchaseItemsByDate({required this.productIds});
}

class SetPurchaseStatusToDefault extends PurchaseEvent {}

class SetPurchaseProductsStatusToDefault extends PurchaseEvent {}

class ProductDownloadEvent extends PurchaseEvent {
  final String productId;

  const ProductDownloadEvent({required this.productId});
}

class SetPurchaseDownloadStatusToDefault extends PurchaseEvent {}
