import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/domain/usecases/stripe/make_payments_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/stripe/stripe_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/stripe_values.dart';
import 'stripe_bloc_test.mocks.dart';

@GenerateMocks([
  MakePaymentsUseCase,
  Stripe,
])
void main() {
  late StripeBloc stripeBloc;
  late MockMakePaymentsUseCase mockMakePaymentsUseCase;
  late MockStripe mockStripe;

  setUp(() {
    mockMakePaymentsUseCase = MockMakePaymentsUseCase();
    mockStripe = MockStripe();

    stripeBloc = StripeBloc(
      mockMakePaymentsUseCase,
    );
  });

  tearDown(() {
    stripeBloc.close();
  });

  // TODO: need to implement
  // blocTest<StripeBloc, StripeState>(
  //   'emits [loading, success] when MakePaymentRequestEvent is added and payment is successful',
  //   build: () {
  //     when(mockMakePaymentsUseCase.call(paymentAmount))
  //         .thenAnswer((_) async => Right(stripeModel));

  //     when(mockStripe.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: stripeModel.client_secret,
  //         merchantDisplayName: 'Pixelcart',
  //       ),
  //     )).thenAnswer((_) async => null);

  //     when(mockStripe.presentPaymentSheet()).thenAnswer((_) async => null);

  //     return stripeBloc;
  //   },
  //   act: (bloc) => bloc.add(MakePaymentRequestEvent(amount: paymentAmount)),
  //   expect: () => [
  //     const StripeState().copyWith(status: BlocStatus.loading),
  //     const StripeState().copyWith(status: BlocStatus.success, message: ''),
  //   ],
  // );

  blocTest<StripeBloc, StripeState>(
    'emits [loading, error] when MakePaymentRequestEvent is added and payment fails',
    build: () {
      final failure = StripeFailure(errorMessage: 'Payment failed');
      when(mockMakePaymentsUseCase.call(stripePaymentAmount))
          .thenAnswer((_) async => Left(failure));

      return stripeBloc;
    },
    act: (bloc) =>
        bloc.add(MakePaymentRequestEvent(amount: stripePaymentAmount)),
    expect: () => [
      const StripeState().copyWith(status: BlocStatus.loading),
      const StripeState().copyWith(
        status: BlocStatus.error,
        message: 'Payment failed',
      ),
    ],
  );

  blocTest<StripeBloc, StripeState>(
    'emits updated state with status and message when SetStripePaymentValuesToDefault is added',
    build: () => stripeBloc,
    act: (bloc) => bloc.add(SetStripePaymentValuesToDefault()),
    expect: () => [
      StripeState().copyWith(
        status: BlocStatus.initial,
        message: '',
      ),
    ],
  );
}
