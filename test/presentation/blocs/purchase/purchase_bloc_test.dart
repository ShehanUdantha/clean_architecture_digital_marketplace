import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/download_product_by_product_id_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_history_by_user_id_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/cart/purchase/get_all_purchase_items_by_product_id_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/purchase/purchase_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'purchase_bloc_test.mocks.dart';

@GenerateMocks([
  GetAllPurchaseHistoryByUserIdUseCase,
  GetAllPurchaseItemsByItsProductIdsUseCase,
  DownloadProductByProductIdUsecase,
])
void main() {
  late PurchaseBloc purchaseBloc;
  late MockGetAllPurchaseHistoryByUserIdUseCase
      mockGetAllPurchaseHistoryByUserIdUseCase;
  late MockGetAllPurchaseItemsByItsProductIdsUseCase
      mockGetAllPurchaseItemsByItsProductIdsUseCase;
  late MockDownloadProductByProductIdUsecase
      mockDownloadProductByProductIdUsecase;

  setUp(() {
    mockGetAllPurchaseHistoryByUserIdUseCase =
        MockGetAllPurchaseHistoryByUserIdUseCase();
    mockGetAllPurchaseItemsByItsProductIdsUseCase =
        MockGetAllPurchaseItemsByItsProductIdsUseCase();
    mockDownloadProductByProductIdUsecase =
        MockDownloadProductByProductIdUsecase();
    purchaseBloc = PurchaseBloc(
      mockGetAllPurchaseHistoryByUserIdUseCase,
      mockGetAllPurchaseItemsByItsProductIdsUseCase,
      mockDownloadProductByProductIdUsecase,
    );
  });

  tearDown(() {
    purchaseBloc.close();
  });

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [loading, success, listOfPurchase] when GetAllPurchaseHistory is added and use case return list of purchases',
    build: () {
      when(mockGetAllPurchaseHistoryByUserIdUseCase.call(any))
          .thenAnswer((_) async => Right(dummyPurchasedProductEntities));

      return purchaseBloc;
    },
    act: (bloc) => bloc.add(GetAllPurchaseHistory()),
    expect: () => [
      PurchaseState().copyWith(status: BlocStatus.loading),
      PurchaseState().copyWith(
        status: BlocStatus.success,
        listOfPurchase: dummyPurchasedProductEntities,
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [loading, error, message] when GetAllPurchaseHistory fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchase history failed',
      );
      when(mockGetAllPurchaseHistoryByUserIdUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return purchaseBloc;
    },
    act: (bloc) => bloc.add(GetAllPurchaseHistory()),
    expect: () => [
      PurchaseState().copyWith(status: BlocStatus.loading),
      PurchaseState().copyWith(
        status: BlocStatus.error,
        message: 'Get all purchase history failed',
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [loading, success, listOfPurchaseProducts] when GetAllPurchaseItemsByItsProductIds is added and use case return list of purchased products',
    build: () {
      when(mockGetAllPurchaseItemsByItsProductIdsUseCase
              .call(fakeProductIdList))
          .thenAnswer((_) async => Right(dummyProductEntities));

      return purchaseBloc;
    },
    act: (bloc) => bloc
        .add(GetAllPurchaseItemsByItsProductIds(productIds: fakeProductIdList)),
    expect: () => [
      PurchaseState().copyWith(productStatus: BlocStatus.loading),
      PurchaseState().copyWith(
        productStatus: BlocStatus.success,
        listOfPurchaseProducts: dummyProductEntities,
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [loading, error, productMessage] when GetAllPurchaseItemsByItsProductIds fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all purchased products by ids failed',
      );
      when(mockGetAllPurchaseItemsByItsProductIdsUseCase
              .call(fakeProductIdList))
          .thenAnswer((_) async => Left(failure));

      return purchaseBloc;
    },
    act: (bloc) => bloc
        .add(GetAllPurchaseItemsByItsProductIds(productIds: fakeProductIdList)),
    expect: () => [
      PurchaseState().copyWith(productStatus: BlocStatus.loading),
      PurchaseState().copyWith(
        productStatus: BlocStatus.error,
        productMessage: 'Get all purchased products by ids failed',
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits updated state with status and message when SetPurchaseStatusToDefault is added',
    build: () => purchaseBloc,
    act: (bloc) => bloc.add(SetPurchaseStatusToDefault()),
    expect: () => [
      PurchaseState().copyWith(
        status: BlocStatus.initial,
        message: '',
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits updated state with productStatus and productMessage when SetPurchaseProductsStatusToDefault is added',
    build: () => purchaseBloc,
    act: (bloc) => bloc.add(SetPurchaseProductsStatusToDefault()),
    expect: () => [
      PurchaseState().copyWith(
        productStatus: BlocStatus.initial,
        productMessage: '',
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [loading, success] when ProductDownloadEvent is added and use case return success',
    build: () {
      when(mockDownloadProductByProductIdUsecase.call(fakeProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return purchaseBloc;
    },
    act: (bloc) => bloc.add(ProductDownloadEvent(productId: fakeProductId)),
    expect: () => [
      PurchaseState().copyWith(downloadStatus: BlocStatus.success),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits [error, downloadMessage] when ProductDownloadEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Product download failed',
      );
      when(mockDownloadProductByProductIdUsecase.call(fakeProductId))
          .thenAnswer((_) async => Left(failure));

      return purchaseBloc;
    },
    act: (bloc) => bloc.add(ProductDownloadEvent(productId: fakeProductId)),
    expect: () => [
      PurchaseState().copyWith(
        downloadStatus: BlocStatus.error,
        downloadMessage: 'Product download failed',
      ),
    ],
  );

  blocTest<PurchaseBloc, PurchaseState>(
    'emits updated state with downloadStatus and downloadMessage when SetPurchaseDownloadStatusToDefault is added',
    build: () => purchaseBloc,
    act: (bloc) => bloc.add(SetPurchaseDownloadStatusToDefault()),
    expect: () => [
      PurchaseState().copyWith(
        downloadStatus: BlocStatus.initial,
        downloadMessage: '',
      ),
    ],
  );
}
