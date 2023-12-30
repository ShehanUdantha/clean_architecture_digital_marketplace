import 'package:equatable/equatable.dart';

class StripeEntity extends Equatable {
  final String id;
  final int amount;
  final String client_secret;
  final String currency;

  const StripeEntity({
    required this.id,
    required this.amount,
    required this.client_secret,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        client_secret,
        currency,
      ];
}
