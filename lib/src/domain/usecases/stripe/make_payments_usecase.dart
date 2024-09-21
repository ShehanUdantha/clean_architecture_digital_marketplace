import '../../../core/error/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/stripe/stripe_entity.dart';
import 'package:dartz/dartz.dart';

import '../../repositories/stripe/stripe_repository.dart';

class MakePaymentsUseCase extends UseCase<StripeEntity, double> {
  final StripeRepository stripeRepository;

  MakePaymentsUseCase({required this.stripeRepository});

  @override
  Future<Either<Failure, StripeEntity>> call(double params) async {
    return await stripeRepository.makePayments(params);
  }
}
