part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetAllCartedProductsDetailsByIdEvent extends CartEvent {}

class UpdateCartedProductsDetailsByIdEvent extends CartEvent {}

class DeleteCartedProductEvent extends CartEvent {
  final String id;

  const DeleteCartedProductEvent({required this.id});
}

class SetCartStateToDefaultEvent extends CartEvent {}

class CountTotalPrice extends CartEvent {}

class SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent
    extends CartEvent {}

class SetAddToPurchaseStatusToDefault extends CartEvent {}
