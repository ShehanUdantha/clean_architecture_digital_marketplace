import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/purchase_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/cart/purchase_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/purchase_values.dart';
import 'purchase_repository_impl_test.mocks.dart';

@GenerateMocks([PurchaseRemoteDataSource, NetworkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PurchaseRepositoryImpl purchaseRepositoryImpl;
  late MockPurchaseRemoteDataSource mockPurchaseRemoteDataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockPurchaseRemoteDataSource = MockPurchaseRemoteDataSource();
    mockNetworkService = MockNetworkService();
    purchaseRepositoryImpl = PurchaseRepositoryImpl(
      purchaseRemoteDataSource: mockPurchaseRemoteDataSource,
      networkService: mockNetworkService,
    );
  });

  group(
    'getAllPurchaseHistoryByUserId',
    () {
      test(
        'should return a List of PurchaseProductsModels when the get all purchase history by user id process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllPurchaseHistoryByUserId())
              .thenAnswer((_) async => purchaseModels);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByUserId();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, purchaseModels),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase history by user id process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all purchase history by user id failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllPurchaseHistoryByUserId())
              .thenThrow(dbException);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByUserId();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all purchase history by user id failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all purchase history by user id process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByUserId();

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllPurchaseItemsByProductId',
    () {
      test(
        'should return a List of ProductsModels when the get all purchase items by product id process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseItemsByItsProductIds(purchasedProductIdList))
              .thenAnswer((_) async => purchasedProductModels);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseItemsByProductId(purchasedProductIdList);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, purchasedProductModels),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase items by product id process fails',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          final dbException = DBException(
            errorMessage: 'Get all purchase items by product id failed',
          );
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseItemsByItsProductIds(purchasedProductIdList))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseItemsByProductId(purchasedProductIdList);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all purchase items by product id failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all purchase items by product id process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await purchaseRepositoryImpl
              .getAllPurchaseItemsByProductId(purchasedProductIdList);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'downloadProductByProductId',
    () {
      test(
        'should return a Product file URL when the download product by product id process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource
                  .downloadProductByProductId(purchasedProductId))
              .thenAnswer((_) async => purchasedProductUrl);

          // Act
          final result = await purchaseRepositoryImpl
              .downloadProductByProductId(purchasedProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, purchasedProductUrl),
          );
        },
      );

      test(
        'should return a Failure when the download product by product id process fails',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          final dbException = DBException(
            errorMessage: 'Download product by product id failed',
          );
          when(mockPurchaseRemoteDataSource
                  .downloadProductByProductId(purchasedProductId))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .downloadProductByProductId(purchasedProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Download product by product id failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the download product by product id process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await purchaseRepositoryImpl
              .downloadProductByProductId(purchasedProductId);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllPurchaseHistoryByMonth',
    () {
      test(
        'should return a Map of purchase history for the provided month when the get all purchase history by month process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenAnswer((_) async => purchaseHistoryByYearAndMonth);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, purchaseHistoryByYearAndMonth),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase history by month process fails',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          final dbException = DBException(
            errorMessage: 'Get all purchase history by month failed',
          );
          when(mockPurchaseRemoteDataSource.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenThrow(dbException);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all purchase history by month failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all purchase history by month process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllPurchasesTotalBalanceByMonth',
    () {
      test(
        'should return a Total purchase amount for the provided month when the get all purchase total balance by month process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenAnswer((_) async => totalPurchaseAmountByYearAndMonth);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, totalPurchaseAmountByYearAndMonth),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase total balance by month process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all purchase total balance by month failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenThrow(dbException);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all purchase total balance by month failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all purchase total balance by month process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await purchaseRepositoryImpl.getAllPurchasesTotalBalanceByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllPurchasesTotalBalancePercentageByMonth',
    () {
      test(
        'should return a Total purchase amount percentage for the provided month when the get all purchase total balance percentage by month process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalancePercentageByMonth(
                      yearAndMonthParamsToGetPurchaseHistory))
              .thenAnswer(
                  (_) async => totalPurchaseAmountPercentageByYearAndMonth);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalancePercentageByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, totalPurchaseAmountPercentageByYearAndMonth),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase total balance percentage by month process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage:
                'Get all purchase total balance percentage by month failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalancePercentageByMonth(
                      yearAndMonthParamsToGetPurchaseHistory))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalancePercentageByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          final failure = FirebaseFailure(
            errorMessage:
                'Get all purchase total balance percentage by month failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get all purchase total balance percentage by month process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );

          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalancePercentageByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);
          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllTopSellingProductsByMonth',
    () {
      test(
        'should return a List of top selling products for the provided month when the get top selling products by month process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenAnswer((_) async => topSellingProductModelsByYearAndMonth);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, topSellingProductModelsByYearAndMonth),
          );
        },
      );

      test(
        'should return a Failure when the get top selling products by month process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get top selling products by month failed',
          );
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockPurchaseRemoteDataSource.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory))
              .thenThrow(dbException);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get top selling products by month failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );

      test(
        'should return a Failure when network fails in the get top selling products by month process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await purchaseRepositoryImpl.getAllTopSellingProductsByMonth(
                  yearAndMonthParamsToGetPurchaseHistory);

          // Assert
          result.fold(
            (l) {
              expect(l, failure);
            },
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}
