import '../../models/product/product_model.dart';

import '../../../core/error/failure.dart';
import '../../data_sources/remote/cart/cart_remote_data_source.dart';
import '../../../domain/repositories/cart/cart_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource cartRemoteDataSource;

  CartRepositoryImpl({required this.cartRemoteDataSource});

  @override
  Future<Either<Failure, String>> addProductToCart(String id) async {
    try {
      final result = await cartRemoteDataSource.addProductToCart(id);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCartedItems() async {
    try {
      final result = await cartRemoteDataSource.getCartedItems();
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllCartedItemsDetails() async {
    try {
      final result = await cartRemoteDataSource.getAllCartedItemsDetailsById();
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> removeProductFromCart(String id) async {
    try {
      final result = await cartRemoteDataSource.removeProductFromCart(id);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> setCartDetailsToPurchaseHistoryAndDeleteCart(
      String price) async {
    try {
      final result = await cartRemoteDataSource
          .setCartDetailsToPurchaseHistoryAndDeleteCart(price);
      return Right(result);
    } on DBException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    } on AuthException catch (e) {
      return Left(FirebaseFailure(errorMessage: e.errorMessage));
    }
  }
}
