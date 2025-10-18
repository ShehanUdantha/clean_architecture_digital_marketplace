import 'dart:convert';

import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/constants/urls.dart';
import 'package:Pixelcart/src/core/error/exception.dart';
import 'package:Pixelcart/src/data/data_sources/remote/stripe/stripe_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/stripe_values.dart';
import 'stripe_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttpClient;
  late StripRemoteDataSourceImpl stripRemoteDataSource;

  setUp(() {
    mockHttpClient = MockClient();
    stripRemoteDataSource = StripRemoteDataSourceImpl(client: mockHttpClient);
  });

  group(
    'makePayments',
    () {
      test(
        'should return a StripeModel when the response status code is 200',
        () async {
          // Arrange
          when(mockHttpClient.post(
            Uri.parse(AppUrls.stripeBaseUrl),
            headers: anyNamed('headers'),
            body: {
              "amount": (stripePaymentAmount.ceil() * 100).toString(),
              "currency": "usd",
              "payment_method_types[]": "card",
            },
          )).thenAnswer(
              (_) async => http.Response(jsonEncode(stripeJson), 200));

          // Act
          final result =
              await stripRemoteDataSource.makePayments(stripePaymentAmount);

          // Assert
          expect(result, stripeModel);
        },
      );

      test(
        'should throw StripesException when the response status code is not 200',
        () async {
          // Arrange
          when(mockHttpClient.post(
            Uri.parse(AppUrls.stripeBaseUrl),
            headers: anyNamed('headers'),
            body: {
              "amount": (stripePaymentAmount.ceil() * 100).toString(),
              "currency": "usd",
              "payment_method_types[]": "card",
            },
          )).thenAnswer((_) async => http.Response(
              jsonEncode({
                'error': {'message': AppErrorMessages.stripPaymentFail}
              }),
              400));

          // Act & Assert
          await expectLater(
            () => stripRemoteDataSource.makePayments(stripePaymentAmount),
            throwsA(
              isA<StripesException>().having(
                (e) => e.errorMessage,
                'message',
                AppErrorMessages.stripPaymentFail,
              ),
            ),
          );
        },
      );

      test(
        'should throw StripesException for unexpected errors',
        () async {
          // Arrange
          when(mockHttpClient.post(
            Uri.parse(AppUrls.stripeBaseUrl),
            headers: anyNamed('headers'),
            body: {
              "amount": (stripePaymentAmount.ceil() * 100).toString(),
              "currency": "usd",
              "payment_method_types[]": "card",
            },
          )).thenThrow(StripesException(errorMessage: 'Make payments failed'));

          // Act & Assert
          await expectLater(
            () => stripRemoteDataSource.makePayments(stripePaymentAmount),
            throwsA(
              isA<StripesException>().having(
                (e) => e.errorMessage,
                'message',
                'Make payments failed',
              ),
            ),
          );
        },
      );
    },
  );
}
