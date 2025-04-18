import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/data/data_sources/remote/stripe/stripe_remote_data_source.dart';
import 'package:Pixelcart/src/data/repositories/stripe/stripe_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/stripe_values.dart';
import 'stripe_repository_impl_test.mocks.dart';

@GenerateMocks([StripeRemoteDataSource])
void main() {
  late StripeRepositoryImpl stripeRepositoryImpl;
  late MockStripeRemoteDataSource mockStripeRemoteDataSource;

  setUp(() {
    mockStripeRemoteDataSource = MockStripeRemoteDataSource();
    stripeRepositoryImpl = StripeRepositoryImpl(
        stripeRemoteDataSource: mockStripeRemoteDataSource);
  });

  group(
    'makePayments',
    () {
      test(
        'should return a Strip payment details when the make payments process is successful',
        () async {
          // Arrange
          when(mockStripeRemoteDataSource.makePayments(paymentAmount))
              .thenAnswer((_) async => stripeModel);

          // Act
          final result = await stripeRepositoryImpl.makePayments(paymentAmount);

          // Assert
          result.fold(
            (l) => fail('test failed'),
            (r) => expect(r, stripeModel),
          );
        },
      );

      test(
        'should return a Failure when the make payments process fails',
        () async {
          // Arrange
          final stripeException = StripeException(
            errorMessage: 'Make payments failed',
          );
          when(mockStripeRemoteDataSource.makePayments(paymentAmount))
              .thenThrow(stripeException);

          // Act
          final result = await stripeRepositoryImpl.makePayments(paymentAmount);

          // Assert
          final failure = StripeFailure(
            errorMessage: 'Make payments failed',
          );
          result.fold(
            (l) => expect(l, failure),
            (r) => fail('test failed'),
          );
        },
      );
    },
  );
}
