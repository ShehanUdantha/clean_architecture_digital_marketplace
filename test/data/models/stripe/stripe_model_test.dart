import 'package:Pixelcart/src/data/models/stripe/stripe_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/constant_values.dart';

void main() {
  test(
    'should correctly create StripeModel from Map',
    () {
      // Act
      final stripeFromMap = StripeModel.fromMap(dummyStripeJson);

      // Assert
      expect(stripeFromMap, equals(dummyStripeModel));
    },
  );
}
