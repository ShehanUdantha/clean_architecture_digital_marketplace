part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final String productName;
  final String price;
  final String category;
  final String marketingType;
  final String description;
  final BlocStatus status;
  final String message;

  const AddProductState({
    this.productName = '',
    this.price = '',
    this.category = '',
    this.marketingType = '',
    this.description = '',
    this.status = BlocStatus.initial,
    this.message = '',
  });

  AddProductState copyWith({
    String? productName,
    String? price,
    String? category,
    String? marketingType,
    String? description,
    BlocStatus? status,
    String? message,
  }) =>
      AddProductState(
        productName: productName ?? this.productName,
        price: price ?? this.price,
        category: category ?? this.category,
        marketingType: marketingType ?? this.marketingType,
        description: description ?? this.description,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object> get props => [
        productName,
        price,
        category,
        marketingType,
        description,
        status,
        message,
      ];
}
