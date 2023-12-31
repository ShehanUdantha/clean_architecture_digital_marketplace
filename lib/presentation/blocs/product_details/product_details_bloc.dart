import 'dart:async';

import '../../../core/utils/extension.dart';
import '../../../domain/usecases/product/add_favorite_usecase.dart';
import 'package:bloc/bloc.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/enum.dart';
import '../../../domain/usecases/cart/get_carted_items_usecase.dart';
import '../../../domain/usecases/product/get_product_details_by_id_usecase.dart';
import '../../../domain/usecases/cart/remove_product_from_cart_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/cart/add_product_to_cart_usecase.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsByIdUseCase getProductDetailsByIdUseCase;
  final AddProductToCartUseCase addProductToCartUseCase;
  final GetCartedItemsUseCase getCartedItemsUseCase;
  final RemoveProductFromCartUseCase removeProductFromCartUseCase;
  final AddFavoriteUseCase addFavoriteUseCase;

  ProductDetailsBloc(
    this.getProductDetailsByIdUseCase,
    this.addProductToCartUseCase,
    this.getCartedItemsUseCase,
    this.removeProductFromCartUseCase,
    this.addFavoriteUseCase,
  ) : super(const ProductDetailsState()) {
    on<GetProductDetailsEvent>(onGetProductDetailsEvent);
    on<ChangeCurrentSubImageNumberEvent>(onChangeCurrentSubImageNumberEvent);
    on<AddProductToCartEvent>(onAddProductToCart);
    on<GetCartedItemsEvent>(onGetCartedItems);
    on<RemoveProductFromCartEvent>(onRemoveProductFromCartEvent);
    on<SetProductDetailsToDefaultEvent>(onSetProductDetailsToDefaultEvent);
    on<AddFavoriteToProductEvent>(onAddFavoriteToProductEvent);
    on<SetProductFavoriteToDefaultEvent>(onSetProductFavoriteToDefaultEvent);
  }

  FutureOr<void> onGetProductDetailsEvent(
    GetProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getProductDetailsByIdUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          productEntity: r,
          status: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onChangeCurrentSubImageNumberEvent(
    ChangeCurrentSubImageNumberEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(state.copyWith(currentSubImageNumber: event.index));
  }

  FutureOr<void> onAddProductToCart(
    AddProductToCartEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(state.copyWith(cartedStatus: BlocStatus.loading));

    final result = await addProductToCartUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          cartedStatus: BlocStatus.error,
          cartedMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          cartedMessage: CURDTypes.add.curd,
          cartedStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onGetCartedItems(
    GetCartedItemsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final result = await getCartedItemsUseCase.call(NoParams());
    result.fold(
      (l) => null,
      (r) => emit(
        state.copyWith(
          cartedItems: r,
        ),
      ),
    );
  }

  FutureOr<void> onRemoveProductFromCartEvent(
    RemoveProductFromCartEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(state.copyWith(cartedStatus: BlocStatus.loading));

    final result = await removeProductFromCartUseCase.call(event.id);
    result.fold(
      (l) => emit(
        state.copyWith(
          cartedStatus: BlocStatus.error,
          cartedMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          cartedMessage: CURDTypes.remove.curd,
          cartedStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSetProductDetailsToDefaultEvent(
    SetProductDetailsToDefaultEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(state.copyWith(
      cartedStatus: BlocStatus.initial,
      cartedMessage: '',
    ));
  }

  FutureOr<void> onAddFavoriteToProductEvent(
    AddFavoriteToProductEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final result = await addFavoriteUseCase.call(state.productEntity.id!);

    result.fold(
      (l) => emit(
        state.copyWith(
          favoriteStatus: BlocStatus.error,
          favoriteMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          productEntity: r,
          favoriteStatus: BlocStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> onSetProductFavoriteToDefaultEvent(
    SetProductFavoriteToDefaultEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        favoriteMessage: '',
        favoriteStatus: BlocStatus.initial,
      ),
    );
  }
}
