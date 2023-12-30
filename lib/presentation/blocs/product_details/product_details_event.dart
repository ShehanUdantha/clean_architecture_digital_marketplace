part of 'product_details_bloc.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final String id;

  const GetProductDetailsEvent({required this.id});
}

class ChangeCurrentSubImageNumberEvent extends ProductDetailsEvent {
  final int index;

  const ChangeCurrentSubImageNumberEvent({required this.index});
}

class AddProductToCartEvent extends ProductDetailsEvent {
  final String id;

  const AddProductToCartEvent({required this.id});
}

class GetCartedItemsEvent extends ProductDetailsEvent {}

class RemoveProductFromCartEvent extends ProductDetailsEvent {
  final String id;

  const RemoveProductFromCartEvent({required this.id});
}

class SetProductDetailsToDefaultEvent extends ProductDetailsEvent {}

class AddFavoriteToProductEvent extends ProductDetailsEvent {}

class SetProductFavoriteToDefaultEvent extends ProductDetailsEvent {}
