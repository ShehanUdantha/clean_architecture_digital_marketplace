import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../entities/product/product_entity.dart';
import '../../../repositories/cart/purchase_repository.dart';
import 'year_and_month_params.dart';

class GetTopSellingProductsByMonthUseCase
    extends UseCase<List<ProductEntity>, YearAndMonthParams> {
  final PurchaseRepository purchaseRepository;
  GetTopSellingProductsByMonthUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      YearAndMonthParams params) async {
    return await purchaseRepository.getAllTopSellingProductsByMonth(params);
  }
}
