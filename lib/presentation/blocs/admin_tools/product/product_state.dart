part of 'product_bloc.dart';

class ProductState extends Equatable {
  final BlocStatus status;
  final String message;
  final List<ProductEntity> listOfProducts;
  final bool isDeleted;
  final bool isEdit;
  final int currentCategory;
  final String currentCategoryName;

  const ProductState({
    this.status = BlocStatus.initial,
    this.message = '',
    this.listOfProducts = const [],
    this.isDeleted = false,
    this.isEdit = false,
    this.currentCategory = 0,
    this.currentCategoryName = 'All Items',
  });

  ProductState copyWith({
    BlocStatus? status,
    String? message,
    List<ProductEntity>? listOfProducts,
    bool? isDeleted,
    bool? isEdit,
    int? currentCategory,
    String? currentCategoryName,
  }) =>
      ProductState(
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
        status,
        message,
        listOfProducts,
        isDeleted,
        isEdit,
        currentCategory,
        currentCategoryName,
      ];
}
