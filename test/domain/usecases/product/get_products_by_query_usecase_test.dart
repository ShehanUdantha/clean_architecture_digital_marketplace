import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_products_by_query_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'get_products_by_query_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProductsByQueryUseCase getProductsByQueryUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProductsByQueryUseCase =
        GetProductsByQueryUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a List of products when the get products by search query process is successful',
    () async {
      // Arrange
      when(mockProductRepository.getProductsByQuery(fakeProductSearchQuery))
          .thenAnswer((_) async => Right(searchQueryDummyResult));

      // Act
      final result =
          await getProductsByQueryUseCase.call(fakeProductSearchQuery);

      // Assert
      expect(result, Right(searchQueryDummyResult));
    },
  );

  test(
    'should return a Failure when the get products by search query process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get products by search query failed',
      );
      when(mockProductRepository.getProductsByQuery(fakeProductSearchQuery))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getProductsByQueryUseCase.call(fakeProductSearchQuery);

      // Assert
      expect(result, Left(failure));
    },
  );
}
