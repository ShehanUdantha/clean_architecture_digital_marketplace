import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/stripe_values.dart';

void main() {
  test(
    'should create a valid Stripe Entity instance',
    () async {
      expect(stripeEntity.id, 'stripe_12345');
      expect(stripeEntity.amount, 1000);
      expect(stripeEntity.client_secret, 'sk_test_4eC39HqLyjWDjt');
      expect(stripeEntity.currency, 'USD');
    },
  );
}
