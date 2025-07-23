// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/services/network_service.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repositories/cart/cart_repository.dart';
import '../../data_sources/remote/cart/cart_remote_data_source.dart';
import '../../models/product/product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource cartRemoteDataSource;
  final NetworkService networkService;

  CartRepositoryImpl({
    required this.cartRemoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, String>> addProductToCart(String productId) async {
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

      final result = await cartRemoteDataSource.addProductToCart(productId);
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
  Future<Either<Failure, List<String>>> getCartedItems() async {
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

      final result = await cartRemoteDataSource.getCartedItems();
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
  Future<Either<Failure, List<ProductModel>>> getAllCartedItemsDetails() async {
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

      final result = await cartRemoteDataSource.getAllCartedItemsDetailsById();
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
  Future<Either<Failure, String>> removeProductFromCart(
      String productId) async {
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

      final result =
          await cartRemoteDataSource.removeProductFromCart(productId);
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
  Future<Either<Failure, String>> setCartDetailsToPurchaseHistoryAndDeleteCart(
      String price) async {
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

      final result = await cartRemoteDataSource
          .setCartDetailsToPurchaseHistoryAndDeleteCart(price);
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
