import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/purchase_repository.dart';

class GetAllPurchaseBalancePercentageByMonthUseCase
    extends UseCase<double, YearAndMonthParams> {
  final PurchaseRepository purchaseRepository;
  GetAllPurchaseBalancePercentageByMonthUseCase(
      {required this.purchaseRepository});

  @override
  Future<Either<Failure, double>> call(YearAndMonthParams params) async {
    return await purchaseRepository
        .getAllPurchasesTotalBalancePercentageByMonth(
      params.year,
      params.month,
    );
  }
}
