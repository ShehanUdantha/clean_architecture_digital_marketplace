import 'package:Pixelcart/src/data/models/stripe/stripe_model.dart';
import 'package:Pixelcart/src/domain/entities/stripe/stripe_entity.dart';

const double paymentAmount = 1000.00;

const StripeModel stripeModel = StripeModel(
  id: 'stripe_12345',
  amount: 1000,
  client_secret: 'sk_test_4eC39HqLyjWDjt',
  currency: 'USD',
);

const stripeJson = {
  'id': 'stripe_12345',
  'amount': 1000,
  'client_secret': 'sk_test_4eC39HqLyjWDjt',
  'currency': 'USD',
};

const StripeEntity stripeEntity = StripeEntity(
  id: 'stripe_12345',
  amount: 1000,
  client_secret: 'sk_test_4eC39HqLyjWDjt',
  currency: 'USD',
);
