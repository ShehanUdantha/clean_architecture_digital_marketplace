import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/cart/purchase_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/cart/purchase_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'purchase_repository_impl_test.mocks.dart';

@GenerateMocks([PurchaseRemoteDataSource])
void main() {
  late PurchaseRepositoryImpl purchaseRepositoryImpl;
  late MockPurchaseRemoteDataSource mockPurchaseRemoteDataSource;

  setUp(() {
    mockPurchaseRemoteDataSource = MockPurchaseRemoteDataSource();
    purchaseRepositoryImpl = PurchaseRepositoryImpl(
        purchaseRemoteDataSource: mockPurchaseRemoteDataSource);
  });

  group(
    'getAllPurchaseHistoryByUserId',
    () {
      test(
        'should return a List of PurchaseProductsModels when the get all purchase history by user id process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource.getAllPurchaseHistoryByUserId())
              .thenAnswer((_) async => dummyPurchasedProducts);

          // Act
          final result =
              await purchaseRepositoryImpl.getAllPurchaseHistoryByUserId();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyPurchasedProducts),
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
    },
  );

  group(
    'getAllPurchaseItemsByProductId',
    () {
      test(
        'should return a List of ProductsModels when the get all purchase items by product id process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseItemsByItsProductIds(fakeProductIdList))
              .thenAnswer((_) async => dummyProducts);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseItemsByProductId(fakeProductIdList);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyProducts),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase items by product id process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all purchase items by product id failed',
          );
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseItemsByItsProductIds(fakeProductIdList))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseItemsByProductId(fakeProductIdList);

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
    },
  );

  group(
    'downloadProductByProductId',
    () {
      test(
        'should return a Success Status when the download product by product id process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .downloadProductByProductId(fakeProductId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await purchaseRepositoryImpl
              .downloadProductByProductId(fakeProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the download product by product id process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Download product by product id failed',
          );
          when(mockPurchaseRemoteDataSource
                  .downloadProductByProductId(fakeProductId))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .downloadProductByProductId(fakeProductId);

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
    },
  );

  group(
    'getAllPurchaseHistoryByMonth',
    () {
      test(
        'should return a Map of purchase history for the provided month when the get all purchase history by month process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseHistoryByMonth(yearAndMonthParams))
              .thenAnswer((_) async => fakePurchaseHistoryByMonth);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseHistoryByMonth(yearAndMonthParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fakePurchaseHistoryByMonth),
          );
        },
      );

      test(
        'should return a Failure when the get all purchase history by month process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all purchase history by month failed',
          );
          when(mockPurchaseRemoteDataSource
                  .getAllPurchaseHistoryByMonth(yearAndMonthParams))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchaseHistoryByMonth(yearAndMonthParams);

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
    },
  );

  group(
    'getAllPurchasesTotalBalanceByMonth',
    () {
      test(
        'should return a Total purchase amount for the provided month when the get all purchase total balance by month process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalanceByMonth(yearAndMonthParams))
              .thenAnswer((_) async => fakeTotalPurchaseAmount);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalanceByMonth(yearAndMonthParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fakeTotalPurchaseAmount),
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
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalanceByMonth(yearAndMonthParams))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalanceByMonth(yearAndMonthParams);

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
    },
  );

  group(
    'getAllPurchasesTotalBalancePercentageByMonth',
    () {
      test(
        'should return a Total purchase amount percentage for the provided month when the get all purchase total balance percentage by month process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalancePercentageByMonth(
                      yearAndMonthParams))
              .thenAnswer((_) async => fakeTotalPurchaseAmountPercentage);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalancePercentageByMonth(yearAndMonthParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fakeTotalPurchaseAmountPercentage),
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
          when(mockPurchaseRemoteDataSource
                  .getAllPurchasesTotalBalancePercentageByMonth(
                      yearAndMonthParams))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllPurchasesTotalBalancePercentageByMonth(yearAndMonthParams);

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
    },
  );

  group(
    'getAllTopSellingProductsByMonth',
    () {
      test(
        'should return a List of top selling products for the provided month when the get top selling products by month process is successful',
        () async {
          // Arrange
          when(mockPurchaseRemoteDataSource
                  .getAllTopSellingProductsByMonth(yearAndMonthParams))
              .thenAnswer((_) async => dummyTopSellingProducts);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllTopSellingProductsByMonth(yearAndMonthParams);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyTopSellingProducts),
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
          when(mockPurchaseRemoteDataSource
                  .getAllTopSellingProductsByMonth(yearAndMonthParams))
              .thenThrow(dbException);

          // Act
          final result = await purchaseRepositoryImpl
              .getAllTopSellingProductsByMonth(yearAndMonthParams);

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
    },
  );
}
