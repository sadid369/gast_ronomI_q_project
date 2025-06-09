import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';

import '../subscription_plans/subscription_plans.dart';

class PaypalPage extends StatelessWidget {
  final SubscriptionPlan plan;

  const PaypalPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with PayPal'),
        backgroundColor: Colors.blueAccent,
      ),
      body: UsePaypal(
        sandboxMode: true,
        clientId:
            "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0", // Replace with your actual PayPal client id
        secretKey:
            "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9", // Replace with your secret key
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount": {
              "total": plan.price,
              "currency": "USD",
              "details": {
                "subtotal": plan.price,
                "shipping": '0',
                "shipping_discount": 0,
              }
            },
            "description": "Subscription payment for ${plan.title}",
            "item_list": {
              "items": [
                {
                  "name": plan.title,
                  "quantity": 1,
                  "price": plan.price,
                  "currency": "USD",
                }
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (params) {
          print("Payment success: $params");
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Successful!')),
          );
        },
        onError: (error) {
          print("Payment error: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment Error: $error')),
          );
        },
        onCancel: (params) {
          print("Payment cancelled: $params");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment Cancelled')),
          );
        },
      ),
    );
  }
}
