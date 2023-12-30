part of 'stripe_bloc.dart';

class StripeState extends Equatable {
  final StripeEntity stripeIntentResponse;
  final BlocStatus status;
  final String message;
  final BlocStatus paymentStatus;
  final String paymentMessage;
  final BlocStatus paymentSheetStatus;
  final String paymentSheetMessage;

  const StripeState({
    this.stripeIntentResponse = const StripeEntity(
      id: '',
      amount: 0,
      client_secret: '',
      currency: '',
    ),
    this.status = BlocStatus.initial,
    this.message = '',
    this.paymentStatus = BlocStatus.initial,
    this.paymentMessage = '',
    this.paymentSheetStatus = BlocStatus.initial,
    this.paymentSheetMessage = '',
  });

  StripeState copyWith({
    StripeEntity? stripeIntentResponse,
    BlocStatus? status,
    String? message,
    BlocStatus? paymentStatus,
    String? paymentMessage,
    BlocStatus? paymentSheetStatus,
    String? paymentSheetMessage,
  }) =>
      StripeState(
        stripeIntentResponse: stripeIntentResponse ?? this.stripeIntentResponse,
        status: status ?? this.status,
        message: message ?? this.message,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentMessage: paymentMessage ?? this.paymentMessage,
        paymentSheetStatus: paymentSheetStatus ?? this.paymentSheetStatus,
        paymentSheetMessage: paymentSheetMessage ?? this.paymentSheetMessage,
      );

  @override
  List<Object> get props => [
        stripeIntentResponse,
        status,
        message,
        paymentStatus,
        paymentMessage,
        paymentSheetStatus,
        paymentSheetMessage,
      ];
}
