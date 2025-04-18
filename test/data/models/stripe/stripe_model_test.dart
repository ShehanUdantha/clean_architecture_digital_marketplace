import 'package:Pixelcart/src/data/models/stripe/stripe_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/stripe_values.dart';

void main() {
  test(
    'should correctly create StripeModel from Map',
    () {
      // Act
      final stripeFromMap = StripeModel.fromMap(stripeJson);

      // Assert
      expect(stripeFromMap, equals(stripeModel));
    },
  );
}
