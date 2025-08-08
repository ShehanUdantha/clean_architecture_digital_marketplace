import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../entities/cart/purchase_entity.dart';
import '../../entities/product/product_entity.dart';
import '../../usecases/cart/purchase/year_and_month_params.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, List<PurchaseEntity>>> getAllPurchaseHistoryByUserId();
  Future<Either<Failure, List<ProductEntity>>> getAllPurchaseItemsByProductId(
      PurchaseEntity purchaseDetails);
  Future<Either<Failure, Map<String, int>>> getAllPurchaseHistoryByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, double>> getAllPurchasesTotalBalanceByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, double>> getAllPurchasesTotalBalancePercentageByMonth(
      YearAndMonthParams yearAndMonthParams);
  Future<Either<Failure, List<ProductEntity>>> getAllTopSellingProductsByMonth(
      YearAndMonthParams yearAndMonthParams);
}
