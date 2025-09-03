// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:dartz/dartz.dart';

import 'package:Pixelcart/src/core/services/network_service.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/product/product_entity.dart';
import '../../../domain/entities/cart/purchase_entity.dart';
import '../../../domain/repositories/cart/purchase_repository.dart';
import '../../../domain/usecases/cart/purchase/year_and_month_params.dart';
import '../../data_sources/remote/cart/purchase_remote_data_source.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource purchaseRemoteDataSource;
  final NetworkService networkService;

  PurchaseRepositoryImpl({
    required this.purchaseRemoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, List<PurchaseEntity>>>
      getAllPurchaseHistoryByUserId() async {
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
      PurchaseEntity purchaseDetails) async {
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

      final result = await purchaseRemoteDataSource
          .getAllPurchaseItemsByItsProductIds(purchaseDetails);
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
      YearAndMonthParams yearAndMonthParams) async {
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

      final result = await purchaseRemoteDataSource
          .getAllPurchaseHistoryByMonth(yearAndMonthParams);
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
      YearAndMonthParams yearAndMonthParams) async {
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

      final result = await purchaseRemoteDataSource
          .getAllPurchasesTotalBalanceByMonth(yearAndMonthParams);
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
      YearAndMonthParams yearAndMonthParams) async {
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

      final result = await purchaseRemoteDataSource
          .getAllPurchasesTotalBalancePercentageByMonth(yearAndMonthParams);
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
      YearAndMonthParams yearAndMonthParams) async {
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

      final result = await purchaseRemoteDataSource
          .getAllTopSellingProductsByMonth(yearAndMonthParams);
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
