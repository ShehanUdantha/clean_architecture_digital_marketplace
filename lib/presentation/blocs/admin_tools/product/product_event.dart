// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CategorySelectEvent extends ProductEvent {
  final int value;
  final String name;

  const CategorySelectEvent({
    required this.value,
    required this.name,
  });
}

class GetAllProductsEvent extends ProductEvent {}

class ProductDeleteEvent extends ProductEvent {
  final String id;

  const ProductDeleteEvent({required this.id});
}

class ProductEditEvent extends ProductEvent {}

class SetProductDeleteStateToDefault extends ProductEvent {}
