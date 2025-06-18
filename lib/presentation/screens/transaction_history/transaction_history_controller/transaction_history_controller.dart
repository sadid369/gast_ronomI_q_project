import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../global/model/transaction_history.dart';

class TransactionHistoryController extends GetxController {
  final history = Rxn<TransactionHistory>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final resp = await http.get(
        Uri.parse(
          'http://10.0.70.145:8001/report/api/v1/daily-category-spending/',
        ),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTMwMjEwLCJpYXQiOjE3NDk5MzgyMTAsImp0aSI6ImNkZmQwZjE4Yjg5OTQ0OGM4YzY1ZWFiOTZhZGUxZjJmIiwidXNlcl9pZCI6MjZ9.RtRRXxJSqzdjQSyxQJ1N4uoPgoNm2Ms1okC8qFMWoBU', // your token
        },
      );

      if (resp.statusCode == 200) {
        history.value = TransactionHistory.fromJson(
            json.decode(resp.body) as Map<String, dynamic>);
      } else {
        errorMessage.value = 'Failed to load history: ${resp.statusCode}';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
