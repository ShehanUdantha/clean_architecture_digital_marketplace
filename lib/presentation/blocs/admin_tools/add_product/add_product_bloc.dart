import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../../../core/utils/extension.dart';
import 'package:bloc/bloc.dart';
import '../../../../core/utils/enum.dart';
import '../../../../domain/entities/product/product_entity.dart';
import '../../../../domain/usecases/product/add_product_usecase.dart';
import 'package:equatable/equatable.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase addProductUseCase;

  AddProductBloc(this.addProductUseCase) : super(const AddProductState()) {
    on<CategoryNameFieldChangeEvent>(onCategoryNameFieldChangeEvent);
    on<MarketingTypeFieldChangeEvent>(onMarketingTypeFieldChangeEvent);
    on<ProductUploadButtonClickedEvent>(onProductUploadButtonClickedEvent);
    on<SetProductStatusToDefault>(onSetProductStatusToDefault);
  }

  FutureOr<void> onCategoryNameFieldChangeEvent(
    CategoryNameFieldChangeEvent event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  FutureOr<void> onMarketingTypeFieldChangeEvent(
    MarketingTypeFieldChangeEvent event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(marketingType: event.type));
  }

  FutureOr<void> onProductUploadButtonClickedEvent(
    ProductUploadButtonClickedEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    ProductEntity productEntity = ProductEntity(
      productName: event.productName,
      price: event.productPrice,
      category: state.category,
      marketingType: state.marketingType,
      description: event.productDescription,
      coverImage: event.coverImage,
      subImages: event.subImages,
      zipFile: event.zipFile,
      likes: const [],
      status: '',
    );

    final result = await addProductUseCase.call(productEntity);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) {
        if (r == ResponseTypes.success.response) {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              message: r,
              status: BlocStatus.error,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> onSetProductStatusToDefault(
    SetProductStatusToDefault event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(
      status: BlocStatus.initial,
      message: '',
    ));
  }
}
