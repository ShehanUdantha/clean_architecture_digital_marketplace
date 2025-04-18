import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/data/data_sources/remote/category/category_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/category/category_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/category_values.dart';
import 'category_repository_impl_test.mocks.dart';

@GenerateMocks([CategoryRemoteDataSource])
void main() {
  late CategoryRepositoryImpl categoryRepositoryImpl;
  late MockCategoryRemoteDataSource mockCategoryRemoteDataSource;

  setUp(() {
    mockCategoryRemoteDataSource = MockCategoryRemoteDataSource();
    categoryRepositoryImpl = CategoryRepositoryImpl(
        categoryRemoteDataSource: mockCategoryRemoteDataSource);
  });

  group(
    'addCategory',
    () {
      test(
        'should return a Success Status when the add category process is successful',
        () async {
          // Arrange
          when(mockCategoryRemoteDataSource.addCategory(categoryTypeFont))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result =
              await categoryRepositoryImpl.addCategory(categoryTypeFont);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the add category process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Add category failed',
          );
          when(mockCategoryRemoteDataSource.addCategory(categoryTypeFont))
              .thenThrow(dbException);

          // Act
          final result =
              await categoryRepositoryImpl.addCategory(categoryTypeFont);

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Add category failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'getAllCategories',
    () {
      test(
        'should return a List of categories when the get all categories process is successful',
        () async {
          // Arrange
          when(mockCategoryRemoteDataSource.getAllCategories())
              .thenAnswer((_) async => categoryModels);

          // Act
          final result = await categoryRepositoryImpl.getAllCategories();

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, categoryModels),
          );
        },
      );

      test(
        'should return a Failure when the get all categories process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Get all categories failed',
          );
          when(mockCategoryRemoteDataSource.getAllCategories())
              .thenThrow(dbException);

          // Act
          final result = await categoryRepositoryImpl.getAllCategories();

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Get all categories failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );

  group(
    'deleteCategory',
    () {
      test(
        'should return a Success Status when the delete category process is successful',
        () async {
          // Arrange
          when(mockCategoryRemoteDataSource
                  .deleteCategory(fontCategoryId.toString()))
              .thenAnswer((_) async => ResponseTypes.success.response);

          // Act
          final result = await categoryRepositoryImpl
              .deleteCategory(fontCategoryId.toString());

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, ResponseTypes.success.response),
          );
        },
      );

      test(
        'should return a Failure when the delete category process fails',
        () async {
          // Arrange
          final dbException = DBException(
            errorMessage: 'Delete category failed',
          );
          when(mockCategoryRemoteDataSource
                  .deleteCategory(fontCategoryId.toString()))
              .thenThrow(dbException);

          // Act
          final result = await categoryRepositoryImpl
              .deleteCategory(fontCategoryId.toString());

          // Assert
          final failure = FirebaseFailure(
            errorMessage: 'Delete category failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}
