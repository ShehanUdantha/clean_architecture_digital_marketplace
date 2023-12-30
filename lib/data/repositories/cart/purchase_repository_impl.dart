import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/data/data_sources/remote/cart/purchase_remote_data_source.dart';
import 'package:Pixelcart/domain/entities/product/product_entity.dart';
import 'package:Pixelcart/domain/entities/product/purchase_products_entity.dart';
import 'package:Pixelcart/domain/repositories/cart/purchase_repository.dart';
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
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllPurchaseItemsByProductId(
      List<String> productIds) async {
    try {
      final result = await purchaseRemoteDataSource
          .getAllPurchaseItemsByProductId(productIds);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> downloadProductByProductId(
      String productId) async {
    try {
      final result =
          await purchaseRemoteDataSource.downloadProductByProductId(productId);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }
}
