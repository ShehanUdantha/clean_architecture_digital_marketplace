import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/delete_product_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'delete_product_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late DeleteProductUseCase deleteProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    deleteProductUseCase =
        DeleteProductUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a Success Status when the delete product process is successful',
    () async {
      // Arrange
      when(mockProductRepository.deleteProduct(deleteProductParams))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await deleteProductUseCase.call(deleteProductParams);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the delete product process fails due to the unauthorized access',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Delete product failed - due to the unauthorized access',
      );
      when(mockProductRepository.deleteProduct(deleteProductParamsTwo))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteProductUseCase.call(deleteProductParamsTwo);

      // Assert
      expect(result, Left(failure));
    },
  );

  test(
    'should return a Failure when the delete product process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Delete product failed',
      );
      when(mockProductRepository.deleteProduct(deleteProductParams))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteProductUseCase.call(deleteProductParams);

      // Assert
      expect(result, Left(failure));
    },
  );
}
