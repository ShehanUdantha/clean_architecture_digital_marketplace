import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/edit_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'edit_product_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late EditProductUseCase editProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    editProductUseCase =
        EditProductUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a Success Status when the edit product process is successful',
    () async {
      // Arrange
      when(mockProductRepository.editProduct(editProductParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await editProductUseCase.call(editProductParams);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure status when attempting to edit a product that does not exist in firestore',
    () async {
      // Arrange
      when(mockProductRepository.editProduct(editProductParams))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      // Act
      final result = await editProductUseCase.call(editProductParams);

      // Assert
      expect(result, Right(ResponseTypes.failure.response));
    },
  );

  test(
    'should return a Failure when the edit product process fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Edit product failed - due to the unauthorized access',
      );
      when(mockProductRepository.editProduct(editProductParamsTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await editProductUseCase.call(editProductParamsTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the edit product process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Edit product failed',
      );
      when(mockProductRepository.editProduct(editProductParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await editProductUseCase.call(editProductParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}
