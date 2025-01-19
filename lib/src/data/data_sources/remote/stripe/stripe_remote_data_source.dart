import 'dart:convert';
import 'package:Pixelcart/src/config/routes/router.dart';
import 'package:Pixelcart/src/core/services/env.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';

import '../../../models/stripe/stripe_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/urls.dart';
import '../../../../core/error/exception.dart';

abstract class StripeRemoteDataSource {
  Future<StripeModel> makePayments(double amount);
}

class StripRemoteDataSourceImpl implements StripeRemoteDataSource {
  final http.Client client;

  StripRemoteDataSourceImpl({required this.client});

  @override
  Future<StripeModel> makePayments(double amount) async {
    try {
      final response = await client.post(
        Uri.parse(AppUrls.stripeBaseUrl),
        headers: {
          "Authorization": "Bearer ${Env.stripeTestSecretKey}",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "amount": (amount.ceil() * 100).toString(),
          "currency": "usd",
          "payment_method_types[]": "card",
        },
      );

      if (response.statusCode == 200) {
        return StripeModel.fromMap(jsonDecode(response.body));
      } else {
        throw StripeException(
            errorMessage: jsonDecode(response.body)['error'] ??
                rootNavigatorKey.currentContext!.loc.stripPaymentFail);
      }
    } catch (e) {
      throw StripeException(errorMessage: e.toString());
    }
  }
}
