// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:dartz/dartz.dart';

import 'package:Pixelcart/src/core/services/network_service.dart';

import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repositories/stripe/stripe_repository.dart';
import '../../data_sources/remote/stripe/stripe_remote_data_source.dart';
import '../../models/stripe/stripe_model.dart';

class StripeRepositoryImpl implements StripeRepository {
  final StripeRemoteDataSource stripeRemoteDataSource;
  final NetworkService networkService;

  StripeRepositoryImpl({
    required this.stripeRemoteDataSource,
    required this.networkService,
  });

  @override
  Future<Either<Failure, StripeModel>> makePayments(double amount) async {
    try {
      if (!await (networkService.isConnected())) {
        return Left(
          NetworkFailure(
            errorMessage: rootNavigatorKey.currentContext != null
                ? rootNavigatorKey.currentContext!.loc.noInternetMessage
                : AppErrorMessages.noInternetMessage,
          ),
        );
      }

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
