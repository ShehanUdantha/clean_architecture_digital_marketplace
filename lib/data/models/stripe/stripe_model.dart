import '../../../domain/entities/stripe/stripe_entity.dart';

class StripeModel extends StripeEntity {
  const StripeModel({
    required super.id,
    required super.amount,
    required super.client_secret,
    required super.currency,
  });

  factory StripeModel.fromMap(Map<String, dynamic> map) => StripeModel(
        id: map['id'],
        amount: map['amount'],
        client_secret: map['client_secret'],
        currency: map['currency'],
      );
}
//  String? id;
// String? object;
// int? amount;
// int? amountCapturable;
// AmountDetails? amountDetails;
// int? amountReceived;
// dynamic application;
// dynamic applicationFeeAmount;
// AutomaticPaymentMethods? automaticPaymentMethods;
// dynamic canceledAt;
// dynamic cancellationReason;
// String? captureMethod;
// String? clientSecret;
// String? confirmationMethod;
// int? created;
// String? currency;
// dynamic customer;
// String? description;
// dynamic invoice;
// dynamic lastPaymentError;
// dynamic latestCharge;
// bool? livemode;
// Metadata? metadata;
// dynamic nextAction;
// dynamic onBehalfOf;
// dynamic paymentMethod;
// dynamic paymentMethodConfigurationDetails;
// PaymentMethodOptions? paymentMethodOptions;
// List<dynamic>? paymentMethodTypes;
// dynamic processing;
// dynamic receiptEmail;
// dynamic review;
// dynamic setupFutureUsage;
// dynamic shipping;
// dynamic statementDescriptor;
// dynamic statementDescriptorSuffix;
// String? status;
// dynamic transferData;
// dynamic transferGroup;
