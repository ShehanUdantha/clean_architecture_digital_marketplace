import 'dart:convert';
import '../../../models/stripe/stripe_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/keys.dart';
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
          "Authorization": "Bearer ${AppKeys.STRIPE_TEST_SECRET_KEY}",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "amount": (amount.ceil() * 100).toString(),
          "currency": "INR",
          "payment_method_types[]": "card",
        },
      );

      return StripeModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      throw StripeException(errorMessage: e.toString());
    }
  }
}
