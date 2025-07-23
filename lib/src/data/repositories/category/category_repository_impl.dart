// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/category/category_entity.dart';
import '../../../domain/repositories/category/category_repository.dart';
import '../../data_sources/remote/category/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final NetworkService networkService;

  CategoryRepositoryImpl({
    required this.categoryRemoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, String>> addCategory(String categoryName) async {
    try {
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

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
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

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
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

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
