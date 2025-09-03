import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/domain/repositories/stripe/stripe_repository.dart';
import 'package:Pixelcart/src/domain/usecases/stripe/make_payments_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/stripe_values.dart';
import 'make_payments_usecase_test.mocks.dart';

@GenerateMocks([StripeRepository])
void main() {
  late MakePaymentsUseCase makePaymentsUseCase;
  late MockStripeRepository mockStripeRepository;

  setUp(() {
    mockStripeRepository = MockStripeRepository();
    makePaymentsUseCase =
        MakePaymentsUseCase(stripeRepository: mockStripeRepository);
  });

  test(
    'should return a Strip payment details when the make payments process is successful',
    () async {
      // Arrange
      when(mockStripeRepository.makePayments(stripePaymentAmount))
          .thenAnswer((_) async => Right(stripeModel));

      // Act
      final result = await makePaymentsUseCase.call(stripePaymentAmount);

      // Assert
      expect(result, Right(stripeModel));
    },
  );

  test(
    'should return a Failure when the make payments process fails',
    () async {
      // Arrange
      final failure = StripeFailure(
        errorMessage: 'Make payments failed',
      );
      when(mockStripeRepository.makePayments(stripePaymentAmount))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await makePaymentsUseCase.call(stripePaymentAmount);

      // Assert
      expect(result, Left(failure));
    },
  );
}
