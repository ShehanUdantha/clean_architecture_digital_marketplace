import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/add_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'add_product_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late AddProductUseCase addProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    addProductUseCase =
        AddProductUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a Success status when a new product is successfully added to firestore',
    () async {
      // Arrange
      when(mockProductRepository.addProduct(dummyProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await addProductUseCase.call(dummyProductEntity);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure status when attempting to add a product that already exists in firestore',
    () async {
      // Arrange
      when(mockProductRepository.addProduct(dummyProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      // Act
      final result = await addProductUseCase.call(dummyProductEntity);

      // Assert
      expect(result, Right(ResponseTypes.failure.response));
    },
  );

  test(
    'should return a Failure status when adding a new product to firestore fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Add new product failed',
      );
      when(mockProductRepository.addProduct(dummyProductEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addProductUseCase.call(dummyProductEntity);

      // Assert
      expect(result, Left(failure));
    },
  );
}
