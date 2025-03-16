import '../../../core/error/failure.dart';
import '../../data_sources/remote/category/category_remote_data_source.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/repositories/category/category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;

  CategoryRepositoryImpl({required this.categoryRemoteDataSource});

  @override
  Future<Either<Failure, String>> addCategory(String categoryName) async {
    try {
      final result = await categoryRemoteDataSource.addCategory(categoryName);
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final result = await categoryRemoteDataSource.getAllCategories();
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> deleteCategory(String categoryId) async {
    try {
      final result = await categoryRemoteDataSource.deleteCategory(categoryId);
      return Right(result);
    } on AuthException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    } on DBException catch (e) {
      return Left(
        FirebaseFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }
}
