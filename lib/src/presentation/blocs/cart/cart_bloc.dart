// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extension.dart';
import '../../../core/utils/helper.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/usecases/cart/get_all_carted_items_details_by_id_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/cart/get_carted_items_usecase.dart';
import '../../../domain/usecases/cart/purchase/set_cart_details_to_purchase_history_and_delete_cart_usecase.dart';
import '../../../domain/usecases/cart/remove_product_from_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartedItemsUseCase getCartedItemsUseCase;
  final GetAllCartedItemsDetailsByIdUseCase getAllCartedItemsDetailsByIdUseCase;
  final RemoveProductFromCartUseCase removeProductFromCartUseCase;
  final SetCartDetailsToPurchaseHistoryAndDeleteCartUseCase
      setCartDetailsToPurchaseHistoryAndDeleteCartUseCase;

  CartBloc(
    this.getCartedItemsUseCase,
    this.getAllCartedItemsDetailsByIdUseCase,
    this.removeProductFromCartUseCase,
    this.setCartDetailsToPurchaseHistoryAndDeleteCartUseCase,
  ) : super(const CartState()) {
    on<GetAllCartedProductsDetailsByIdEvent>(
        onGetAllCartedProductsDetailsByIdEvent);
    on<DeleteCartedProductEvent>(onDeleteCartedProductEvent);
    on<SetCartStateToDefaultEvent>(onSetCartStateToDefaultEvent);
    on<CountTotalPrice>(onCountTotalPrice);
    on<UpdateCartedProductsDetailsByIdEvent>(
        onUpdateCartedProductsDetailsByIdEvent);
    on<SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent>(
        onSetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent);
    on<SetAddToPurchaseStatusToDefault>(onSetAddToPurchaseStatusToDefault);
  }

  FutureOr<void> onGetAllCartedProductsDetailsByIdEvent(
    GetAllCartedProductsDetailsByIdEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllCartedItemsDetailsByIdUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            listOfCartedItems: r,
            status: BlocStatus.success,
            listStatus: BlocStatus.success,
          ),
        );
        add(CountTotalPrice());
      },
    );
  }

  FutureOr<void> onDeleteCartedProductEvent(
    DeleteCartedProductEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await removeProductFromCartUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          listStatus: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          listStatus: BlocStatus.success,
          message: CURDTypes.remove.curd,
        ),
      ),
    );
  }

  FutureOr<void> onSetCartStateToDefaultEvent(
    SetCartStateToDefaultEvent event,
    Emitter<CartState> emit,
  ) {
    emit(
      state.copyWith(
        message: '',
      ),
    );
  }

  FutureOr<void> onCountTotalPrice(
    CountTotalPrice event,
    Emitter<CartState> emit,
  ) {
    double subTotal = Helper.calculateSubTotal(state.listOfCartedItems);
    double transactionFee = Helper.calculateTransactionFee(subTotal);

    emit(
      state.copyWith(
        totalPrice: subTotal + transactionFee,
        subTotal: subTotal,
        transactionFee: transactionFee,
      ),
    );
  }

  FutureOr<void> onUpdateCartedProductsDetailsByIdEvent(
    UpdateCartedProductsDetailsByIdEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await getAllCartedItemsDetailsByIdUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          listStatus: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            listOfCartedItems: r,
            listStatus: BlocStatus.success,
          ),
        );
        add(CountTotalPrice());
      },
    );
  }

  FutureOr<void> onSetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent(
    SetCartDetailsToPurchaseHistoryAndDeleteCartDetailsEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await setCartDetailsToPurchaseHistoryAndDeleteCartUseCase
        .call(state.totalPrice.toString());

    result.fold(
      (l) => emit(
        state.copyWith(
          addToPurchaseStatus: BlocStatus.error,
          addToPurchaseMessage: l.toString(),
        ),
      ),
      (r) => emit(
        state.copyWith(
          addToPurchaseStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSetAddToPurchaseStatusToDefault(
    SetAddToPurchaseStatusToDefault event,
    Emitter<CartState> emit,
  ) {
    emit(
      state.copyWith(
        addToPurchaseMessage: '',
        addToPurchaseStatus: BlocStatus.initial,
        subTotal: 0.0,
        transactionFee: 0.0,
        totalPrice: 0.0,
      ),
    );
  }
}
