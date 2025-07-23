part of 'purchase_bloc.dart';

class PurchaseState extends Equatable {
  final List<PurchaseEntity> listOfPurchase;
  final BlocStatus status;
  final String message;
  final List<ProductEntity> listOfPurchaseProducts;
  final BlocStatus productStatus;
  final String productMessage;

  const PurchaseState({
    this.listOfPurchase = const [],
    this.message = '',
    this.status = BlocStatus.initial,
    this.listOfPurchaseProducts = const [],
    this.productMessage = '',
    this.productStatus = BlocStatus.initial,
  });

  PurchaseState copyWith({
    List<PurchaseEntity>? listOfPurchase,
    BlocStatus? status,
    String? message,
    List<ProductEntity>? listOfPurchaseProducts,
    BlocStatus? productStatus,
    String? productMessage,
  }) =>
      PurchaseState(
        listOfPurchase: listOfPurchase ?? this.listOfPurchase,
        status: status ?? this.status,
        message: message ?? this.message,
        listOfPurchaseProducts:
            listOfPurchaseProducts ?? this.listOfPurchaseProducts,
        productMessage: productMessage ?? this.productMessage,
        productStatus: productStatus ?? this.productStatus,
      );

  @override
  List<Object> get props => [
        listOfPurchase,
        message,
        status,
        listOfPurchaseProducts,
        productMessage,
        productStatus,
      ];
}
