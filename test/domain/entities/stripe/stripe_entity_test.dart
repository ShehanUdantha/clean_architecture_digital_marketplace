import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should create a valid Stripe Entity instance',
    () async {
      expect(dummyStripeEntity.id, 'stripe_12345');
      expect(dummyStripeEntity.amount, 1000);
      expect(dummyStripeEntity.client_secret, 'sk_test_4eC39HqLyjWDjt');
      expect(dummyStripeEntity.currency, 'USD');
    },
  );
}
