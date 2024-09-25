import '../../../entities/product/product_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/purchase_repository.dart';

class GetTopSellingProductsByMonthUseCase
    extends UseCase<List<ProductEntity>, YearAndMonthParams> {
  final PurchaseRepository purchaseRepository;
  GetTopSellingProductsByMonthUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      YearAndMonthParams params) async {
    return await purchaseRepository.getAllTopSellingProductsByMonth(
      params.year,
      params.month,
    );
  }
}
