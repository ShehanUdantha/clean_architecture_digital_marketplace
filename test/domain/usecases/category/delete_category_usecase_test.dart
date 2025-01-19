import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/category/category_repository.dart';
import 'package:Pixelcart/src/domain/usecases/category/delete_category_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'delete_category_usecase_test.mocks.dart';

@GenerateMocks([CategoryRepository])
void main() {
  late DeleteCategoryUseCase deleteCategoryUseCase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    deleteCategoryUseCase =
        DeleteCategoryUseCase(categoryRepository: mockCategoryRepository);
  });

  test(
    'should return a Success Status when the delete category process is successful',
    () async {
      // Arrange
      when(mockCategoryRepository.deleteCategory(fakeProductCategoryId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await deleteCategoryUseCase.call(fakeProductCategoryId);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the delete category process fails',
    () async {
      // Arrange
      final failure = StripeFailure(
        errorMessage: 'Delete category failed',
      );
      when(mockCategoryRepository.deleteCategory(fakeProductCategoryId))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await deleteCategoryUseCase.call(fakeProductCategoryId);

      // Assert
      expect(result, Left(failure));
    },
  );
}
