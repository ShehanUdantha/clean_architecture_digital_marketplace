import '../../../core/error/failure.dart';
import '../../data_sources/remote/cart/purchase_remote_data_source.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/entities/product/purchase_products_entity.dart';
import '../../../domain/repositories/cart/purchase_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource purchaseRemoteDataSource;

  PurchaseRepositoryImpl({required this.purchaseRemoteDataSource});

  @override
  Future<Either<Failure, List<PurchaseProductsEntity>>>
      getAllPurchaseHistoryByUserId() async {
    try {
      final result =
          await purchaseRemoteDataSource.getAllPurchaseHistoryByUserId();
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
  Future<Either<Failure, List<ProductEntity>>> getAllPurchaseItemsByProductId(
      List<String> productIds) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllPurchaseItemsByItsProductIds(productIds);
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
  Future<Either<Failure, String>> downloadProductByProductId(
      String productId) async {
    try {
      final result =
          await purchaseRemoteDataSource.downloadProductByProductId(productId);
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
  Future<Either<Failure, Map<String, int>>> getAllPurchaseHistoryByMonth(
    int year,
    int month,
  ) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllPurchaseHistoryByMonth(year, month);
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
  Future<Either<Failure, double>> getAllPurchasesTotalBalanceByMonth(
    int year,
    int month,
  ) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllPurchasesTotalBalanceByMonth(year, month);
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
  Future<Either<Failure, double>> getAllPurchasesTotalBalancePercentageByMonth(
    int year,
    int month,
  ) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllPurchasesTotalBalancePercentageByMonth(year, month);
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
  Future<Either<Failure, List<ProductEntity>>> getAllTopSellingProductsByMonth(
    int year,
    int month,
  ) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllTopSellingProductsByMonth(year, month);
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
