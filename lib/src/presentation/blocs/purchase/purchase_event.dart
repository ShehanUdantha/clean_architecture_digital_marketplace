part of 'purchase_bloc.dart';

sealed class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object> get props => [];
}

class GetAllPurchaseHistory extends PurchaseEvent {}

class GetAllPurchaseItemsByItsProductIds extends PurchaseEvent {
  final List<String> productIds;

  const GetAllPurchaseItemsByItsProductIds({required this.productIds});
}

class SetPurchaseStatusToDefault extends PurchaseEvent {}

class SetPurchaseProductsStatusToDefault extends PurchaseEvent {}

class ProductDownloadEvent extends PurchaseEvent {
  final String productId;
  final String productName;

  const ProductDownloadEvent({
    required this.productId,
    required this.productName,
  });
}

class SetPurchaseDownloadStatusToDefault extends PurchaseEvent {}
