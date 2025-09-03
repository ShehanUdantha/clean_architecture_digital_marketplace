import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/purchase_repository.dart';
import 'year_and_month_params.dart';

class GetAllPurchaseBalanceByMonthUseCase
    extends UseCase<double, YearAndMonthParams> {
  final PurchaseRepository purchaseRepository;
  GetAllPurchaseBalanceByMonthUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, double>> call(YearAndMonthParams params) async {
    return await purchaseRepository.getAllPurchasesTotalBalanceByMonth(params);
  }
}
