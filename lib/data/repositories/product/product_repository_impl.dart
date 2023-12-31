import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/repositories/product/product_repository.dart';
import '../../data_sources/remote/product/product_remote_data_source.dart';
import '../../models/product/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl({required this.productRemoteDataSource});

  @override
  Future<Either<Failure, String>> addProduct(
      ProductEntity productEntity) async {
    try {
      final result = await productRemoteDataSource.addProduct(productEntity);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts(
      String category) async {
    try {
      final result = await productRemoteDataSource.getAllProducts(category);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct(String id) async {
    try {
      final result = await productRemoteDataSource.deleteProduct(id);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductByMarketingTypes(
      String marketingType) async {
    try {
      final result = await productRemoteDataSource
          .getProductByMarketingTypes(marketingType);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByQuery(
      String query) async {
    try {
      final result = await productRemoteDataSource.getProductByQuery(query);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductDetailsById(String id) async {
    try {
      final result = await productRemoteDataSource.getProductDetailsById(id);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> addFavorite(String id) async {
    try {
      try {
        final result = await productRemoteDataSource.addFavorite(id);
        return Right(result);
      } on DBException catch (e) {
        return Left(FirebaseFailure(errorMessage: e.errorMessage));
      }
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }
}
