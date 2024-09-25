import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../repositories/cart/purchase_repository.dart';

class GetAllPurchaseHistoryByMonthUseCase
    extends UseCase<Map<String, int>, YearAndMonthParams> {
  final PurchaseRepository purchaseRepository;
  GetAllPurchaseHistoryByMonthUseCase({required this.purchaseRepository});

  @override
  Future<Either<Failure, Map<String, int>>> call(
      YearAndMonthParams params) async {
    return await purchaseRepository.getAllPurchaseHistoryByMonth(
      params.year,
      params.month,
    );
  }
}
