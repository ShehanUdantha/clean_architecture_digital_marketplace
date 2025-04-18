part of 'stripe_bloc.dart';

sealed class StripeEvent extends Equatable {
  const StripeEvent();

  @override
  List<Object> get props => [];
}

class MakePaymentRequestEvent extends StripeEvent {
  final double amount;

  const MakePaymentRequestEvent({required this.amount});
}

class InitializePaymentSheetEvent extends StripeEvent {
  final StripeEntity stripeIntentResponse;

  const InitializePaymentSheetEvent({required this.stripeIntentResponse});
}

class PresentPaymentSheetEvent extends StripeEvent {}

class SetStripePaymentValuesToDefault extends StripeEvent {}
