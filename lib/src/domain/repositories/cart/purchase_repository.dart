import '../../usecases/cart/purchase/year_and_month_params.dart';

import '../../entities/product/purchase_products_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/product/product_entity.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, List<PurchaseProductsEntity>>>
      getAllPurchaseHistoryByUserId();
  Future<Either<Failure, List<ProductEntity>>> getAllPurchaseItemsByProductId(
      List<String> productIds);
  Future<Either<Failure, String>> downloadProductByProductId(String productId);
  Future<Either<Failure, Map<String, int>>> getAllPurchaseHistoryByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, double>> getAllPurchasesTotalBalanceByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, double>> getAllPurchasesTotalBalancePercentageByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, List<ProductEntity>>> getAllTopSellingProductsByMonth(
      YearAndMonthParams yearAndMonthParams);
}
