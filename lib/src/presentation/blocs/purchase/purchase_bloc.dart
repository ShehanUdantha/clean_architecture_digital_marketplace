import 'dart:async';

import 'package:Pixelcart/src/core/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/usecases/cart/purchase/download_product_by_product_id_usecase.dart';
import '../../../domain/usecases/cart/purchase/get_all_purchase_history_by_user_id_usecase.dart';
import '../../../domain/usecases/cart/purchase/get_all_purchase_items_by_product_id_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/enum.dart';
import '../../../domain/entities/product/purchase_products_entity.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final GetAllPurchaseHistoryByUserIdUseCase
      getAllPurchaseHistoryByUserIdUseCase;
  final GetAllPurchaseItemsByItsProductIdsUseCase
      getAllPurchaseItemsByProductIdUseCase;
  final DownloadProductByProductIdUsecase downloadProductByProductIdUsecase;

  PurchaseBloc(
    this.getAllPurchaseHistoryByUserIdUseCase,
    this.getAllPurchaseItemsByProductIdUseCase,
    this.downloadProductByProductIdUsecase,
  ) : super(const PurchaseState()) {
    on<GetAllPurchaseHistory>(onGetAllPurchaseHistory);
    on<GetAllPurchaseItemsByItsProductIds>(
        onGetAllPurchaseItemsByItsProductIds);
    on<SetPurchaseStatusToDefault>(onSetPurchaseStatusToDefault);
    on<SetPurchaseProductsStatusToDefault>(
        onSetPurchaseProductsStatusToDefault);
    on<ProductDownloadEvent>(onProductDownloadEvent);
    on<SetPurchaseDownloadStatusToDefault>(
        onSetPurchaseDownloadStatusToDefault);
  }

  FutureOr<void> onGetAllPurchaseHistory(
    GetAllPurchaseHistory event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await getAllPurchaseHistoryByUserIdUseCase.call(NoParams());

    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BlocStatus.success,
          listOfPurchase: r,
        ),
      ),
    );
  }

  FutureOr<void> onGetAllPurchaseItemsByItsProductIds(
    GetAllPurchaseItemsByItsProductIds event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(state.copyWith(productStatus: BlocStatus.loading));

    final result =
        await getAllPurchaseItemsByProductIdUseCase.call(event.productIds);

    result.fold(
      (l) => emit(
        state.copyWith(
          productStatus: BlocStatus.error,
          productMessage: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          productStatus: BlocStatus.success,
          listOfPurchaseProducts: r,
        ),
      ),
    );
  }

  FutureOr<void> onSetPurchaseStatusToDefault(
    SetPurchaseStatusToDefault event,
    Emitter<PurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
        message: '',
      ),
    );
  }

  FutureOr<void> onSetPurchaseProductsStatusToDefault(
    SetPurchaseProductsStatusToDefault event,
    Emitter<PurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        productStatus: BlocStatus.initial,
        productMessage: '',
      ),
    );
  }

  FutureOr<void> onProductDownloadEvent(
    ProductDownloadEvent event,
    Emitter<PurchaseState> emit,
  ) async {
    final result =
        await downloadProductByProductIdUsecase.call(event.productId);

    result.fold(
      (l) => emit(
        state.copyWith(
          downloadStatus: BlocStatus.error,
          downloadMessage: l.errorMessage,
        ),
      ),
      (r) async {
        await Helper.downloadFile(r, event.productName);
        if (!emit.isDone) {
          emit(
            state.copyWith(
              downloadStatus: BlocStatus.success,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetPurchaseDownloadStatusToDefault(
    SetPurchaseDownloadStatusToDefault event,
    Emitter<PurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        downloadStatus: BlocStatus.initial,
        downloadMessage: '',
      ),
    );
  }
}
