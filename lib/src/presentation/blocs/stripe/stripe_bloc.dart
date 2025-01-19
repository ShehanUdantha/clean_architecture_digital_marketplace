import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/enum.dart';
import '../../../domain/entities/stripe/stripe_entity.dart';
import '../../../domain/usecases/stripe/make_payments_usecase.dart';
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
    on<SetStripePaymentValuesToDefault>(onSetStripePaymentValuesToDefault);
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
        add(
          InitializePaymentSheetEvent(stripeIntentResponse: r),
        );
      },
    );
  }

  FutureOr<void> onInitializePaymentSheetEvent(
    InitializePaymentSheetEvent event,
    Emitter<StripeState> emit,
  ) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: event.stripeIntentResponse.client_secret,
          merchantDisplayName: 'Pixelcart',
        ),
      );
      add(PresentPaymentSheetEvent());
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> onPresentPaymentSheetEvent(
    PresentPaymentSheetEvent event,
    Emitter<StripeState> emit,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          message: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlocStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> onSetStripePaymentValuesToDefault(
    SetStripePaymentValuesToDefault event,
    Emitter<StripeState> emit,
  ) {
    emit(
      state.copyWith(
        status: BlocStatus.initial,
        message: '',
      ),
    );
  }
}
