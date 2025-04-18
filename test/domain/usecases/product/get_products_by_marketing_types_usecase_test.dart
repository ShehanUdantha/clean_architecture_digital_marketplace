import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_products_by_marketing_types_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/product_values.dart';
import 'get_products_by_marketing_types_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProductsByMarketingTypeUseCase getProductsByMarketingTypeUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProductsByMarketingTypeUseCase = GetProductsByMarketingTypeUseCase(
        productRepository: mockProductRepository);
  });

  test(
    'should return a List of products when the get products by marketing type process is successful',
    () async {
      // Arrange
      when(mockProductRepository
              .getProductByMarketingTypes(marketingTypeFeatured))
          .thenAnswer((_) async => Right(featuredMarketingTypeProductEntities));

      // Act
      final result =
          await getProductsByMarketingTypeUseCase.call(marketingTypeFeatured);

      // Assert
      expect(result, Right(featuredMarketingTypeProductEntities));
    },
  );

  test(
    'should return a Failure when the get products by marketing type process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get products by marketing type failed',
      );
      when(mockProductRepository
              .getProductByMarketingTypes(marketingTypeFeatured))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result =
          await getProductsByMarketingTypeUseCase.call(marketingTypeFeatured);

      // Assert
      expect(result, Left(failure));
    },
  );
}
