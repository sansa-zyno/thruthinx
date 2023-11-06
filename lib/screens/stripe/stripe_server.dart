import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeServer {
  final String userId;
  final int price;
  StripeServer({required this.price, required this.userId});

  Future<String> createCheckout() async {
    // final auth = "Basic " + base64Encode(utf8.encode('$secretKey'));
    final auth = "Basic " + base64Encode(utf8.encode(dotenv.env['secretKey']!));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          'name': "Yearly Subscription",
          'amount': price.round(),
          'currency': 'usd',
          'quantity': 1,
        }
      ],
      'mode': 'payment',
      'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
      'cancel_url': 'https://cancel.com/'
    };

    try {
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      return result.data['id'];
    } on DioError catch (e) {
      print(e.response);
      throw e;
    }
  }
}
