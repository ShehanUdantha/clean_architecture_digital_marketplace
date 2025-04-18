import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_product_details_by_id_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/product_values.dart';
import 'get_product_details_by_id_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProductDetailsByIdUseCase getProductDetailsByIdUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProductDetailsByIdUseCase =
        GetProductDetailsByIdUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a Product when the get product details by id process is successful',
    () async {
      // Arrange
      when(mockProductRepository.getProductDetailsById(productId))
          .thenAnswer((_) async => Right(productIdThreeEntity));

      // Act
      final result = await getProductDetailsByIdUseCase.call(productId);

      // Assert
      expect(result, Right(productIdThreeEntity));
    },
  );

  test(
    'should return a Failure when the get product details by id process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get product details by id failed',
      );
      when(mockProductRepository.getProductDetailsById(productId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getProductDetailsByIdUseCase.call(productId);

      // Assert
      expect(result, Left(failure));
    },
  );
}
