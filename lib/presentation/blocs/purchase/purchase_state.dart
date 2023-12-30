part of 'purchase_bloc.dart';

class PurchaseState extends Equatable {
  final List<PurchaseProductsEntity> listOfPurchase;
  final BlocStatus status;
  final String message;
  final List<ProductEntity> listOfPurchaseProducts;
  final BlocStatus productStatus;
  final String productMessage;
  final BlocStatus downloadStatus;
  final String downloadMessage;

  const PurchaseState({
    this.listOfPurchase = const [],
    this.message = '',
    this.status = BlocStatus.initial,
    this.listOfPurchaseProducts = const [],
    this.productMessage = '',
    this.productStatus = BlocStatus.initial,
    this.downloadMessage = '',
    this.downloadStatus = BlocStatus.initial,
  });

  PurchaseState copyWith({
    List<PurchaseProductsEntity>? listOfPurchase,
    BlocStatus? status,
    String? message,
    List<ProductEntity>? listOfPurchaseProducts,
    BlocStatus? productStatus,
    String? productMessage,
    BlocStatus? downloadStatus,
    String? downloadMessage,
  }) =>
      PurchaseState(
        listOfPurchase: listOfPurchase ?? this.listOfPurchase,
        status: status ?? this.status,
        message: message ?? this.message,
        listOfPurchaseProducts:
            listOfPurchaseProducts ?? this.listOfPurchaseProducts,
        productMessage: productMessage ?? this.productMessage,
        productStatus: productStatus ?? this.productStatus,
        downloadMessage: downloadMessage ?? this.downloadMessage,
        downloadStatus: downloadStatus ?? this.downloadStatus,
      );

  @override
  List<Object> get props => [
        listOfPurchase,
        message,
        status,
        listOfPurchaseProducts,
        productMessage,
        productStatus,
        downloadMessage,
        downloadStatus,
      ];
}
