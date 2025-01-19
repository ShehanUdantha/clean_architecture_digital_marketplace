import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_all_products_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'get_all_products_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetAllProductsUseCase getAllProductsUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getAllProductsUseCase =
        GetAllProductsUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a List of Products when the get all products by category process is successful',
    () async {
      // Arrange
      when(mockProductRepository.getAllProducts(dummyFontCategoryType))
          .thenAnswer((_) async => Right(dummyFontsCategoryProducts));

      // Act
      final result = await getAllProductsUseCase.call(dummyFontCategoryType);

      // Assert
      expect(result, Right(dummyFontsCategoryProducts));
    },
  );

  test(
    'should return a Failure when the get all products by category process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all products by category failed',
      );
      when(mockProductRepository.getAllProducts(dummyFontCategoryType))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllProductsUseCase.call(dummyFontCategoryType);

      // Assert
      expect(result, Left(failure));
    },
  );
}
