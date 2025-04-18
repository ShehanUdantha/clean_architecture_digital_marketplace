import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/product/product_repository.dart';
import 'package:Pixelcart/src/domain/usecases/product/add_favorite_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/product_values.dart';
import 'add_favorite_usecase_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late AddFavoriteUseCase addFavoriteUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    addFavoriteUseCase =
        AddFavoriteUseCase(productRepository: mockProductRepository);
  });

  test(
    'should return a Product when the add favorite to product process is successful',
    () async {
      // Arrange
      when(mockProductRepository.addFavorite(productId))
          .thenAnswer((_) async => Right(productIdThreeNewEntity));

      // Act
      final result = await addFavoriteUseCase.call(productId);

      // Assert
      expect(result, Right(productIdThreeNewEntity));
    },
  );

  test(
    'should return a Failure when the add favorite to product process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Add favorite to product failed',
      );
      when(mockProductRepository.addFavorite(productId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addFavoriteUseCase.call(productId);

      // Assert
      expect(result, Left(failure));
    },
  );
}
