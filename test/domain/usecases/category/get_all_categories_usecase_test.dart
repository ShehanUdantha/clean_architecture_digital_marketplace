import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/usecases/usecase.dart';
import 'package:Pixelcart/src/domain/repositories/category/category_repository.dart';
import 'package:Pixelcart/src/domain/usecases/category/get_all_categories_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/category_values.dart';
import 'get_all_categories_usecase_test.mocks.dart';

@GenerateMocks([CategoryRepository])
void main() {
  late GetAllCategoriesUseCase getAllCategoriesUseCase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    getAllCategoriesUseCase =
        GetAllCategoriesUseCase(categoryRepository: mockCategoryRepository);
  });

  test(
    'should return a List of categories when the get all categories process is successful',
    () async {
      // Arrange
      when(mockCategoryRepository.getAllCategories())
          .thenAnswer((_) async => Right(categoryEntities));

      // Act
      final result = await getAllCategoriesUseCase.call(NoParams());

      // Assert
      expect(result, Right(categoryEntities));
    },
  );

  test(
    'should return a Failure when the get all categories process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Get all categories failed',
      );
      when(mockCategoryRepository.getAllCategories())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getAllCategoriesUseCase.call(NoParams());

      // Assert
      expect(result, Left(failure));
    },
  );
}
