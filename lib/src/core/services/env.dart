import 'package:envied/envied.dart';

part 'env.g.dart';

// This class is used to manage environment variables securely.
// Ensure you create your own Stripe API keys by following these steps:
// 1. Go to https://dashboard.stripe.com.
// 2. Navigate to the "Developers" section and select "API keys".
// 3. Generate your own publishable and secret keys for testing or production.
// 4. Add the keys to a `.env` file in the root of your project in this format:
//    STRIPE_TEST_PUBLISHABLE_KEY=your_publishable_key_here
//    STRIPE_TEST_SECRET_KEY=your_secret_key_here

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'STRIPE_TEST_PUBLISHABLE_KEY')
  static final String stripeTestPublishableKey = _Env.stripeTestPublishableKey;
  @EnviedField(varName: 'STRIPE_TEST_SECRET_KEY')
  static final String stripeTestSecretKey = _Env.stripeTestSecretKey;
}
