part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<ProductEntity> listOfCartedItems;
  final BlocStatus status;
  final String message;
  final double subTotal;
  final double transactionFee;
  final double totalPrice;
  final BlocStatus listStatus;
  final String addToPurchaseMessage;
  final BlocStatus addToPurchaseStatus;

  const CartState({
    this.listOfCartedItems = const [],
    this.status = BlocStatus.initial,
    this.message = '',
    this.subTotal = 0.0,
    this.transactionFee = 0.0,
    this.totalPrice = 0.0,
    this.listStatus = BlocStatus.initial,
    this.addToPurchaseMessage = '',
    this.addToPurchaseStatus = BlocStatus.initial,
  });

  CartState copyWith({
    List<ProductEntity>? listOfCartedItems,
    BlocStatus? status,
    String? message,
    double? subTotal,
    double? transactionFee,
    double? totalPrice,
    BlocStatus? listStatus,
    String? addToPurchaseMessage,
    BlocStatus? addToPurchaseStatus,
  }) =>
      CartState(
        listOfCartedItems: listOfCartedItems ?? this.listOfCartedItems,
        status: status ?? this.status,
        message: message ?? this.message,
        subTotal: subTotal ?? this.subTotal,
        transactionFee: transactionFee ?? this.transactionFee,
        totalPrice: totalPrice ?? this.totalPrice,
        listStatus: listStatus ?? this.listStatus,
        addToPurchaseMessage: addToPurchaseMessage ?? this.addToPurchaseMessage,
        addToPurchaseStatus: addToPurchaseStatus ?? this.addToPurchaseStatus,
      );

  @override
  List<Object> get props => [
        listOfCartedItems,
        status,
        message,
        subTotal,
        transactionFee,
        totalPrice,
        listStatus,
        addToPurchaseMessage,
        addToPurchaseStatus,
      ];
}
