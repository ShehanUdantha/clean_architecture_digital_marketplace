import '../../entities/stripe/stripe_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';

abstract class StripeRepository {
  Future<Either<Failure, StripeEntity>> makePayments(double amount);
}
