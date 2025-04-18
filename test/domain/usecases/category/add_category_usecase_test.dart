import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/repositories/category/category_repository.dart';
import 'package:Pixelcart/src/domain/usecases/category/add_category_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/category_values.dart';
import 'add_category_usecase_test.mocks.dart';

@GenerateMocks([CategoryRepository])
void main() {
  late AddCategoryUseCase addCategoryUseCase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    addCategoryUseCase =
        AddCategoryUseCase(categoryRepository: mockCategoryRepository);
  });

  test(
    'should return a Success Status when the add category process is successful',
    () async {
      // Arrange
      when(mockCategoryRepository.addCategory(categoryTypeFont))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      // Act
      final result = await addCategoryUseCase.call(categoryTypeFont);

      // Assert
      expect(result, Right(ResponseTypes.success.response));
    },
  );

  test(
    'should return a Failure when the add category process fails',
    () async {
      // Arrange
      final failure = FirebaseFailure(
        errorMessage: 'Add category failed',
      );
      when(mockCategoryRepository.addCategory(categoryTypeFont))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await addCategoryUseCase.call(categoryTypeFont);

      // Assert
      expect(result, Left(failure));
    },
  );
}
