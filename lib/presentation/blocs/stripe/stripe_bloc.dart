import 'dart:async';

import 'package:Pixelcart/core/utils/enum.dart';
import 'package:Pixelcart/domain/entities/stripe/stripe_entity.dart';
import 'package:Pixelcart/domain/usecases/stripe/make_payments_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  final MakePaymentsUseCase makePaymentsUseCase;

  StripeBloc(this.makePaymentsUseCase) : super(const StripeState()) {
    on<MakePaymentRequestEvent>(onMakePaymentRequest);
    on<InitializePaymentSheetEvent>(onInitializePaymentSheetEvent);
    on<PresentPaymentSheetEvent>(onPresentPaymentSheetEvent);
    on<SetStripeStatusToDefault>(onSetStripeStatusToDefault);
    on<SetStripePaymentStatusToDefault>(onSetStripePaymentStatusToDefault);
    on<SetStripePaymentSheetStatusToDefault>(
        onSetStripePaymentSheetStatusToDefault);
  }

  FutureOr<void> onMakePaymentRequest(
    MakePaymentRequestEvent event,
    Emitter<StripeState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final result = await makePaymentsUseCase.call(event.amount);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: BlocStatus.error,
          message: l.errorMessage,
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            stripeIntentResponse: r,
          ),
        );
      },
    );
  }

  FutureOr<void> onInitializePaymentSheetEvent(
    InitializePaymentSheetEvent event,
    Emitter<StripeState> emit,
  ) async {
    try {
      // initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  state.stripeIntentResponse.client_secret,
              merchantDisplayName: 'Pixelcart',
              billingDetails: const BillingDetails(
                address: Address(
                  country: 'IN',
                  city: '',
                  line1: '',
                  line2: '',
                  state: '',
                  postalCode: '',
                ),
              ),
            ),
          )
          .then((value) {});

      emit(state.copyWith(paymentStatus: BlocStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          paymentStatus: BlocStatus.error,
          paymentMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> onPresentPaymentSheetEvent(
    PresentPaymentSheetEvent event,
    Emitter<StripeState> emit,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((e) {});
      emit(state.copyWith(paymentSheetStatus: BlocStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          paymentSheetStatus: BlocStatus.error,
          paymentSheetMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> onSetStripeStatusToDefault(
    SetStripeStatusToDefault event,
    Emitter<StripeState> emit,
  ) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
        message: '',
        stripeIntentResponse: const StripeEntity(
          id: '',
          amount: 0,
          client_secret: '',
          currency: '',
        ),
      ),
    );
  }

  FutureOr<void> onSetStripePaymentStatusToDefault(
    SetStripePaymentStatusToDefault event,
    Emitter<StripeState> emit,
  ) {
    emit(
      state.copyWith(
        paymentMessage: '',
        paymentStatus: BlocStatus.initial,
      ),
    );
  }

  FutureOr<void> onSetStripePaymentSheetStatusToDefault(
    SetStripePaymentSheetStatusToDefault event,
    Emitter<StripeState> emit,
  ) {
    emit(
      state.copyWith(
        paymentSheetMessage: '',
        paymentSheetStatus: BlocStatus.initial,
      ),
    );
  }
}
