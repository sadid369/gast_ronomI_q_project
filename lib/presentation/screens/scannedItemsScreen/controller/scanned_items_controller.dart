import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';

class ReceiptItem {
  final String date;
  final String product;
  final String category;
  final double amount;
  final String status;

  ReceiptItem({
    required this.date,
    required this.product,
    required this.category,
    required this.amount,
    this.status = "Processed",
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json, String date) {
    return ReceiptItem(
      date: date,
      product: json['item_name'] ?? '',
      category: json['category'] ?? '',
      amount: (json['price'] ?? 0.0).toDouble(),
    );
  }
}

class ScannedItemsController extends ChangeNotifier {
  final ApiClient _apiClient = serviceLocator();

  List<ReceiptItem> scannedItems = [];
  bool isLoading = true;
  String errorMessage = '';

  final String _receiptUrl = 'http://10.0.70.145:8001/report/orders/recent/';

  Future<void> fetchReceiptAndItems() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final resp = await _apiClient.get(
        url: _receiptUrl,
        showResult: true,
      );

      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        final data = resp.body as Map<String, dynamic>;
        final String createdAt = data['created_at'] ?? '';
        final itemsJson = data['items'] as List<dynamic>;
        scannedItems = itemsJson
            .map((j) =>
                ReceiptItem.fromJson(j as Map<String, dynamic>, createdAt))
            .toList();
        isLoading = false;
      } else {
        errorMessage = 'Failed to load receipt: '
            '${resp.statusCode}\n${resp.body}';
        isLoading = false;
      }
    } catch (e) {
      errorMessage = 'Error fetching data: $e';
      isLoading = false;
    }
    notifyListeners();
  }
}
