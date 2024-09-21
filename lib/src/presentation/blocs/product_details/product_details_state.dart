part of 'product_details_bloc.dart';

class ProductDetailsState extends Equatable {
  final ProductEntity productEntity;
  final BlocStatus status;
  final String message;
  final int currentSubImageNumber;
  final List<String> cartedItems;
  final BlocStatus cartedStatus;
  final String cartedMessage;
  final BlocStatus favoriteStatus;
  final String favoriteMessage;

  const ProductDetailsState({
    this.productEntity = const ProductEntity(
      productName: '',
      price: '',
      category: '',
      marketingType: '',
      description: '',
      coverImage: '',
      subImages: '',
      zipFile: '',
      likes: [],
      status: '',
    ),
    this.status = BlocStatus.initial,
    this.message = '',
    this.currentSubImageNumber = 0,
    this.cartedItems = const [],
    this.cartedStatus = BlocStatus.initial,
    this.cartedMessage = '',
    this.favoriteStatus = BlocStatus.initial,
    this.favoriteMessage = '',
  });

  ProductDetailsState copyWith({
    ProductEntity? productEntity,
    BlocStatus? status,
    String? message,
    int? currentSubImageNumber,
    List<String>? cartedItems,
    BlocStatus? cartedStatus,
    String? cartedMessage,
    BlocStatus? favoriteStatus,
    String? favoriteMessage,
  }) =>
      ProductDetailsState(
        productEntity: productEntity ?? this.productEntity,
        status: status ?? this.status,
        message: message ?? this.message,
        currentSubImageNumber:
            currentSubImageNumber ?? this.currentSubImageNumber,
        cartedItems: cartedItems ?? this.cartedItems,
        cartedStatus: cartedStatus ?? this.cartedStatus,
        cartedMessage: cartedMessage ?? this.cartedMessage,
        favoriteStatus: favoriteStatus ?? this.favoriteStatus,
        favoriteMessage: favoriteMessage ?? this.favoriteMessage,
      );

  @override
  List<Object> get props => [
        productEntity,
        status,
        message,
        currentSubImageNumber,
        cartedItems,
        cartedStatus,
        cartedMessage,
        favoriteStatus,
        favoriteMessage,
      ];
}
