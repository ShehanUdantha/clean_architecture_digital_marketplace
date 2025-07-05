import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/product/product_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/product/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/category_values.dart';
import '../../../fixtures/product_values.dart';
import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([ProductRemoteDataSource, NetworkService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProductRepositoryImpl productRepositoryImpl;
  late MockProductRemoteDataSource mockProductRemoteDataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockProductRemoteDataSource = MockProductRemoteDataSource();
    mockNetworkService = MockNetworkService();
    productRepositoryImpl = ProductRepositoryImpl(
      productRemoteDataSource: mockProductRemoteDataSource,
      networkService: mockNetworkService,
    );
  });

  group(
    'addProduct',
    () {
      test(
        'should return a Success status when a new product is successfully added to firestore',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.addProduct(newProductEntity))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await productRepositoryImpl.addProduct(newProductEntity);

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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.addProduct(newProductEntity))
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result =
              await productRepositoryImpl.addProduct(newProductEntity);

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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.addProduct(newProductEntity))
              .thenThrow(dbException);

          // Act
          final result =
              await productRepositoryImpl.addProduct(newProductEntity);

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

      test(
        'should return a Failure when network fails in the new product add to firestore process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await productRepositoryImpl.addProduct(newProductEntity);

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
    'getAllProducts',
    () {
      test(
        'should return a List of Products when the get all products by category process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.getAllProducts(categoryTypeFont))
              .thenAnswer((_) async => fontsCategoryProductModels);

          // Act
          final result =
              await productRepositoryImpl.getAllProducts(categoryTypeFont);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, fontsCategoryProductModels),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.getAllProducts(categoryTypeFont))
              .thenThrow(dbException);

          // Act
          final result =
              await productRepositoryImpl.getAllProducts(categoryTypeFont);

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

      test(
        'should return a Failure when network fails in the get all products by category process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await productRepositoryImpl.getAllProducts(categoryTypeFont);

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
    'deleteProduct',
    () {
      test(
        'should return a Success Status when the delete product process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.deleteProduct(productId))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await productRepositoryImpl.deleteProduct(productId);

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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.deleteProduct(productId))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl.deleteProduct(productId);

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

      test(
        'should return a Failure when network fails in the delete product process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await productRepositoryImpl.deleteProduct(productId);

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
    'getProductByMarketingTypes',
    () {
      test(
        'should return a List of products when the get products by marketing type process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource
                  .getProductByMarketingTypes(marketingTypeFeatured))
              .thenAnswer((_) async => featuredMarketingTypeProducts);

          // Act
          final result = await productRepositoryImpl
              .getProductByMarketingTypes(marketingTypeFeatured);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, featuredMarketingTypeProducts),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource
                  .getProductByMarketingTypes(marketingTypeFeatured))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl
              .getProductByMarketingTypes(marketingTypeFeatured);

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

      test(
        'should return a Failure when network fails in the get products by marketing type process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await productRepositoryImpl
              .getProductByMarketingTypes(marketingTypeFeatured);

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
    'getProductsByQuery',
    () {
      test(
        'should return a List of products when the get products by search query process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource
                  .getProductByQuery(productSearchQuery))
              .thenAnswer((_) async => searchQueryResultProductModels);

          // Act
          final result = await productRepositoryImpl
              .getProductsByQuery(productSearchQuery);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, searchQueryResultProductModels),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource
                  .getProductByQuery(productSearchQuery))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl
              .getProductsByQuery(productSearchQuery);

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

      test(
        'should return a Failure when network fails in the get products by search query process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await productRepositoryImpl
              .getProductsByQuery(productSearchQuery);

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
    'getProductDetailsById',
    () {
      test(
        'should return a Product when the get product details by id process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.getProductDetailsById(productId))
              .thenAnswer((_) async => productIdThreeModel);

          // Act
          final result =
              await productRepositoryImpl.getProductDetailsById(productId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, productIdThreeModel),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.getProductDetailsById(productId))
              .thenThrow(dBException);

          // Act
          final result =
              await productRepositoryImpl.getProductDetailsById(productId);

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

      test(
        'should return a Failure when network fails in the get product details by id process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await productRepositoryImpl.getProductDetailsById(productId);

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
    'addFavorite',
    () {
      test(
        'should return a Product when the add favorite to product process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.addFavorite(productId))
              .thenAnswer((_) async => productIdThreeNewModel);

          // Act
          final result = await productRepositoryImpl.addFavorite(productId);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, productIdThreeNewModel),
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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.addFavorite(productId))
              .thenThrow(dBException);

          // Act
          final result = await productRepositoryImpl.addFavorite(productId);

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

      test(
        'should return a Failure when network fails in the add favorite to product process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result = await productRepositoryImpl.addFavorite(productId);

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
    'editProduct',
    () {
      test(
        'should return a Success Status when the edit product process is successful',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.editProduct(editProductEntity))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await productRepositoryImpl.editProduct(editProductEntity);

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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.editProduct(editProductEntity))
              .thenAnswer((_) async => ResponseTypes.failure.response);

          // Act
          final result =
              await productRepositoryImpl.editProduct(editProductEntity);

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
          when(mockNetworkService.isConnected()).thenAnswer((_) async => true);
          when(mockProductRemoteDataSource.editProduct(editProductEntity))
              .thenThrow(dBException);

          // Act
          final result =
              await productRepositoryImpl.editProduct(editProductEntity);

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

      test(
        'should return a Failure when network fails in the edit product process',
        () async {
          // Arrange
          when(mockNetworkService.isConnected()).thenAnswer((_) async => false);

          // Act
          final failure = NetworkFailure(
            errorMessage: AppErrorMessages.noInternetMessage,
          );
          final result =
              await productRepositoryImpl.editProduct(editProductEntity);

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
