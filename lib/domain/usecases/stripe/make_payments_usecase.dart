import 'package:Pixelcart/core/error/failure.dart';
import 'package:Pixelcart/core/usecases/usecase.dart';
import 'package:Pixelcart/domain/entities/stripe/stripe_entity.dart';
import 'package:Pixelcart/domain/stripe/stripe_repository.dart';
import 'package:dartz/dartz.dart';

class MakePaymentsUseCase extends UseCase<StripeEntity, double> {
  final StripeRepository stripeRepository;

  MakePaymentsUseCase({required this.stripeRepository});

  @override
  Future<Either<Failure, StripeEntity>> call(double params) async {
    return await stripeRepository.makePayments(params);
  }
}
