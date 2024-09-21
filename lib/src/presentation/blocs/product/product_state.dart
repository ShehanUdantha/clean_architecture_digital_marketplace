part of 'product_bloc.dart';

class ProductState extends Equatable {
  final String productName;
  final String price;
  final String category;
  final String marketingType;
  final String description;
  final BlocStatus productAddAndEditStatus;
  final String productAddAndEditMessage;

  final BlocStatus status;
  final String message;
  final List<ProductEntity> listOfProducts;
  final bool isDeleted;
  final bool isEdit;
  final int currentCategory;
  final String currentCategoryName;

  const ProductState({
    this.productName = '',
    this.price = '',
    this.category = '',
    this.marketingType = '',
    this.description = '',
    this.productAddAndEditStatus = BlocStatus.initial,
    this.productAddAndEditMessage = '',
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfProducts = const [],
    this.isDeleted = false,
    this.isEdit = false,
    this.currentCategory = 0,
    this.currentCategoryName = 'All Items',
  });

  ProductState copyWith({
    String? productName,
    String? price,
    String? category,
    String? marketingType,
    String? description,
    BlocStatus? productAddAndEditStatus,
    String? productAddAndEditMessage,
    BlocStatus? status,
    String? message,
    List<ProductEntity>? listOfProducts,
    bool? isDeleted,
    bool? isEdit,
    int? currentCategory,
    String? currentCategoryName,
  }) =>
      ProductState(
        productName: productName ?? this.productName,
        price: price ?? this.price,
        category: category ?? this.category,
        marketingType: marketingType ?? this.marketingType,
        description: description ?? this.description,
        productAddAndEditStatus:
            productAddAndEditStatus ?? this.productAddAndEditStatus,
        productAddAndEditMessage:
            productAddAndEditMessage ?? this.productAddAndEditMessage,
        status: status ?? this.status,
        message: message ?? this.message,
        listOfProducts: listOfProducts ?? this.listOfProducts,
        isDeleted: isDeleted ?? this.isDeleted,
        isEdit: isEdit ?? this.isEdit,
        currentCategory: currentCategory ?? this.currentCategory,
        currentCategoryName: currentCategoryName ?? this.currentCategoryName,
      );

  @override
  List<Object> get props => [
        productName,
        price,
        category,
        marketingType,
        description,
        productAddAndEditStatus,
        productAddAndEditMessage,
        status,
        message,
        listOfProducts,
        isDeleted,
        isEdit,
        currentCategory,
        currentCategoryName,
      ];
}
