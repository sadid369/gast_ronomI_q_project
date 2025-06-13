import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:http/http.dart' as http;
import 'package:groc_shopy/global/model/subscription_plan.dart';

import '../core/routes/route_path.dart';

class PaymentService {
  static const String _baseUrl = 'http://10.0.70.145:8001';
  static const String _createPaymentIntentEndpoint =
      '/subscription/api/v1/create-payment-intent/';
  static const String _subscriptionPlansEndpoint =
      '/subscriptions_plan/api/v1/subscription/plans/';

  // Fetch available subscription plans
  static Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_subscriptionPlansEndpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((plan) => SubscriptionPlan.fromJson(plan)).toList();
      } else {
        throw Exception(
            'Failed to load subscription plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscription plans: $e');
    }
  }

  // Create payment intent with selected plan
  static Future<String?> createPaymentIntent(String planId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_createPaymentIntentEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'plan_id': planId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['client_secret'];
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // Initialize payment sheet
  static Future<void> initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'GrocShopy',
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.amber,
            ),
          ),
        ),
      );
    } catch (e) {
      throw Exception('Failed to initialize payment sheet: $e');
    }
  }

  // Present payment sheet
  static Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw Exception('Payment was cancelled');
      } else {
        throw Exception('Payment failed: ${e.error.message}');
      }
    } catch (e) {
      throw Exception('Payment failed: ${e.toString()}');
    }
  }

  // Simplified payment handler
  static Future<void> handlePayment(
    String planId,
    BuildContext context, {
    String planName = '',
  }) async {
    try {
      // Show loading indicator using root navigator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get client secret
      final clientSecret = await createPaymentIntent(planId);
      if (clientSecret == null) throw Exception('Failed to get client secret');

      // Initialize payment sheet
      await initializePaymentSheet(clientSecret);

      // Dismiss loading using root navigator
      Navigator.of(context, rootNavigator: true).pop();

      // Present payment sheet
      final success = await presentPaymentSheet();

      if (success && context.mounted) {
        _showSuccessDialog(context, planName);
      }
    } catch (e) {
      // Dismiss loading if still showing
      if (context.mounted) {
        // Navigator.of(context, rootNavigator: true).pop();
        _showErrorDialog(context, e.toString());
      }
    }
  }

  static void _showSuccessDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(planName.isNotEmpty
            ? '$planName subscription activated successfully!'
            : 'Subscription activated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally navigate somewhere
              context.go(RoutePath.home.addBasePath);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
