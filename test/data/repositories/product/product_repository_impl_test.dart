import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/product/product_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/product/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductRemoteDataSource])
void main() {
  late ProductRepositoryImpl productRepositoryImpl;
  late MockProductRemoteDataSource mockProductRemoteDataSource;

  setUp(() {
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    productRepositoryImpl = ProductRepositoryImpl(
        productRemoteDataSource: mockProductRemoteDataSource);
  });

  group(
    'addProduct',
    () {
      test(
        'should return a Success status when a new product is successfully added to firestore',
        () async {
          // Arrange
          when(mockProductRemoteDataSource.addProduct(dummyProductEntity))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await productRepositoryImpl.addProduct(dummyProductEntity);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure status when attempting to add a product that already exists in firestore',
        () async {
          // Arrange
          when(mockProductRemoteDataSource.addProduct(dummyProductEntity))
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result =
              await productRepositoryImpl.addProduct(dummyProductEntity);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.failure.response),
          );
        },
      );

      test(
        'should return a Failure status when adding a new product to firestore fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Add new product failed',
          );
          when(mockProductRemoteDataSource.addProduct(dummyProductEntity))
              .thenThrow(dbException);

          // Act
          final result =
              await productRepositoryImpl.addProduct(dummyProductEntity);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Add new product failed',
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
    'getAllProducts',
    () {
      test(
        'should return a List of Products when the get all products by category process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource
                  .getAllProducts(dummyFontCategoryType))
              .thenAnswer((_) async => dummyFontsCategoryProducts);

          // Act
          final result =
              await productRepositoryImpl.getAllProducts(dummyFontCategoryType);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyFontsCategoryProducts),
          );
        },
      );

      test(
        'should return a Failure when the get all products by category process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all products by category failed',
          );
          when(mockProductRemoteDataSource
                  .getAllProducts(dummyFontCategoryType))
              .thenThrow(dbException);

          // Act
          final result =
              await productRepositoryImpl.getAllProducts(dummyFontCategoryType);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all products by category failed',
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
    'deleteProduct',
    () {
      test(
        'should return a Success Status when the delete product process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource.deleteProduct(fakeProductId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await productRepositoryImpl.deleteProduct(fakeProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the delete product process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Delete product failed',
          );
          when(mockProductRemoteDataSource.deleteProduct(fakeProductId))
              .thenThrow(dBException);

          // Act
          final result =
              await productRepositoryImpl.deleteProduct(fakeProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Delete product failed',
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
    'getProductByMarketingTypes',
    () {
      test(
        'should return a List of products when the get products by marketing type process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource
                  .getProductByMarketingTypes(dummyMarketingType))
              .thenAnswer((_) async => dummyFeaturedMarketingTypeProducts);

          // Act
          final result = await productRepositoryImpl
              .getProductByMarketingTypes(dummyMarketingType);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyFeaturedMarketingTypeProducts),
          );
        },
      );

      test(
        'should return a Failure when the get products by marketing type process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Get products by marketing type failed',
          );
          when(mockProductRemoteDataSource
                  .getProductByMarketingTypes(dummyMarketingType))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl
              .getProductByMarketingTypes(dummyMarketingType);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get products by marketing type failed',
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
    'getProductsByQuery',
    () {
      test(
        'should return a List of products when the get products by search query process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource
                  .getProductByQuery(fakeProductSearchQuery))
              .thenAnswer((_) async => searchQueryDummyResult);

          // Act
          final result = await productRepositoryImpl
              .getProductsByQuery(fakeProductSearchQuery);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyFeaturedMarketingTypeProducts),
          );
        },
      );

      test(
        'should return a Failure when the get products by search query process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Get products by search query failed',
          );
          when(mockProductRemoteDataSource
                  .getProductByQuery(fakeProductSearchQuery))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl
              .getProductsByQuery(fakeProductSearchQuery);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get products by search query failed',
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
    'getProductDetailsById',
    () {
      test(
        'should return a Product when the get product details by id process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource.getProductDetailsById(fakeProductId))
              .thenAnswer((_) async => dummyProduct);

          // Act
          final result =
              await productRepositoryImpl.getProductDetailsById(fakeProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyProduct),
          );
        },
      );

      test(
        'should return a Failure when the get product details by id process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Get product details by id failed',
          );
          when(mockProductRemoteDataSource.getProductDetailsById(fakeProductId))
              .thenThrow(dBException);

          // Act
          final result =
              await productRepositoryImpl.getProductDetailsById(fakeProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get product details by id failed',
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
    'addFavorite',
    () {
      test(
        'should return a Product when the add favorite to product process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource.addFavorite(fakeProductId))
              .thenAnswer((_) async => dummyProduct);

          // Act
          final result = await productRepositoryImpl.addFavorite(fakeProductId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, dummyProduct),
          );
        },
      );

      test(
        'should return a Failure when the add favorite to product process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Add favorite to product failed',
          );
          when(mockProductRemoteDataSource.addFavorite(fakeProductId))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl.addFavorite(fakeProductId);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Add favorite to product failed',
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
    'editProduct',
    () {
      test(
        'should return a Success Status when the edit product process is successful',
        () async {
          // Arrange
          when(mockProductRemoteDataSource
                  .editProduct(dummyProductEntityForEdit))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await productRepositoryImpl
              .editProduct(dummyProductEntityForEdit);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure status when attempting to edit a product that does not exist in firestore',
        () async {
          // Arrange
          when(mockProductRemoteDataSource
                  .editProduct(dummyProductEntityForEdit))
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result = await productRepositoryImpl
              .editProduct(dummyProductEntityForEdit);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.failure.response),
          );
        },
      );

      test(
        'should return a Failure when the edit product process fails',
        () async {
          // Arrange
          final dBException = DBException(
            errorMessage: 'Edit product failed',
          );
          when(mockProductRemoteDataSource
                  .editProduct(dummyProductEntityForEdit))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl
              .editProduct(dummyProductEntityForEdit);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Edit product failed',
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
