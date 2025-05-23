import 'package:dartz/dartz.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repositories/stripe/stripe_repository.dart';
import '../../data_sources/remote/stripe/stripe_remote_data_source.dart';
import '../../models/stripe/stripe_model.dart';

class StripeRepositoryImpl implements StripeRepository {
  final StripeRemoteDataSource stripeRemoteDataSource;

  StripeRepositoryImpl({required this.stripeRemoteDataSource});

  @override
  Future<Either<Failure, StripeModel>> makePayments(double amount) async {
    try {
      final result = await stripeRemoteDataSource.makePayments(amount);
      return Right(result);
    } on StripeException catch (e) {
      return Left(
        StripeFailure(
          errorMessage: e.errorMessage,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }
}
