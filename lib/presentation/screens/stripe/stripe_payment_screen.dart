// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class StripePaymentScreen extends StatefulWidget {
//   @override
//   _StripePaymentScreenState createState() => _StripePaymentScreenState();
// }

// class _StripePaymentScreenState extends State<StripePaymentScreen> {
//   bool isLoading = false;

//   // Your API endpoint that returns the client_secret
//   final String apiUrl =
//       'http://10.0.70.145:8001/subscription/api/v1/create-payment-intent/';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stripe Payment'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Complete Payment',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _handlePayment,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 ),
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text('Pay Now', style: TextStyle(fontSize: 18)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handlePayment() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       // Step 1: Get client_secret from your API
//       final clientSecret = await _getClientSecretFromAPI();

//       if (clientSecret == null) {
//         throw Exception('Failed to get client secret');
//       }

//       // Step 2: Initialize payment sheet
//       await _initializePaymentSheet(clientSecret);

//       // Step 3: Present payment sheet
//       await _presentPaymentSheet();
//     } catch (e) {
//       _showErrorDialog('Payment failed: ${e.toString()}');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<String?> _getClientSecretFromAPI() async {
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           // Add any authentication headers if needed
//           // 'Authorization': 'Bearer YOUR_TOKEN',
//         },
//         body: jsonEncode({
//           // Add any required parameters for your API
//           'amount': 2000, // Amount in cents (e.g., $20.00)
//           'currency': 'usd',
//           // Add other parameters as needed
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['client_secret'];
//       } else {
//         throw Exception('API call failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error getting client secret: $e');
//       return null;
//     }
//   }

//   Future<void> _initializePaymentSheet(String clientSecret) async {
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: clientSecret,
//         merchantDisplayName: 'Your App Name',
//         style: ThemeMode.system,
//         // Optional: Customize appearance
//         appearance: PaymentSheetAppearance(
//           colors: PaymentSheetAppearanceColors(
//             primary: Colors.blue,
//           ),
//         ),
//         // Optional: Enable Google Pay
//         // googlePay: PaymentSheetGooglePay(
//         //   merchantCountryCode: 'US',
//         //   currencyCode: 'USD',
//         //   testEnv: true, // Set to false for production
//         // ),
//         // // Optional: Enable Apple Pay
//         // applePay: PaymentSheetApplePay(
//         //   merchantCountryCode: 'US',
//         // ),
//       ),
//     );
//   }

//   Future<void> _presentPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();

//       // Payment successful
//       _showSuccessDialog('Payment completed successfully!');
//     } on StripeException catch (e) {
//       // Handle Stripe-specific errors
//       if (e.error.code == FailureCode.Canceled) {
//         _showErrorDialog('Payment was cancelled');
//       } else {
//         _showErrorDialog('Payment failed: ${e.error.message}');
//       }
//     }
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Success'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
