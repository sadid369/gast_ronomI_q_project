import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/presentation/screens/profile/controller/profile_controller.dart';
import 'package:groc_shopy/service/api_url.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../utils/app_const/app_const.dart';

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

class ScannedItemsController extends GetxController {
  final ApiClient _apiClient = serviceLocator();
  ProfileController? _profileController;
  
  final RxList<ReceiptItem> _scannedItems = <ReceiptItem>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  // Track current user session
  String? _lastUserRole;
  int? _lastUserId;

  // Getters
  List<ReceiptItem> get scannedItems => _scannedItems;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    debugPrint("ScannedItemsController onInit called");
    
    // Always start fresh
    _clearAllData();
    
    // Initialize ProfileController if available
    if (Get.isRegistered<ProfileController>()) {
      _profileController = Get.find<ProfileController>();
    }
    
    // Start fetching data
    fetchReceiptAndItems();
  }

  Future<void> fetchReceiptAndItems() async {
    debugPrint("Starting fetchReceiptAndItems...");
    
    // Get current user info
    final currentRole = await SharedPrefsHelper.getString(AppConstants.userRole);
    final currentUserId = await SharedPrefsHelper.getInt(AppConstants.userID);
    
    // Check if user session has changed
    if (_hasUserSessionChanged(currentRole, currentUserId)) {
      debugPrint("User session changed - clearing data and fetching fresh");
      _clearAllData();
      _lastUserRole = currentRole;
      _lastUserId = currentUserId;
    }
    
    _isLoading.value = true;
    _errorMessage.value = '';
    _scannedItems.clear();

    try {
      debugPrint("User role: $currentRole, User ID: $currentUserId");

      String url;
      if (currentRole == "employee" && currentUserId != null) {
        debugPrint("Fetching for employee ID: $currentUserId");
        url = "${ApiUrl.employeeRecentOrders}$currentUserId".addBaseUrl;
      } else {
        debugPrint("Fetching for admin/client role: $currentRole");
        url = ApiUrl.lastScanInvoiceItems.addBaseUrl;
      }

      debugPrint("Fetching receipt from URL: $url");

      final resp = await _apiClient.get(
        url: url,
        showResult: true,
      );

      debugPrint("API Response - Status: ${resp.statusCode}");

      if (resp.statusCode != null &&
          resp.statusCode! >= 200 &&
          resp.statusCode! < 300) {
        
        // Fetch profile orders if controller is available
        await _profileController?.fetchOrders();

        final data = resp.body as Map<String, dynamic>;
        final String createdAt = data['created_at'] ?? '';
        final itemsJson = data['items'] as List<dynamic>;

        _scannedItems.value = itemsJson
            .map((j) =>
                ReceiptItem.fromJson(j as Map<String, dynamic>, createdAt))
            .toList();

        debugPrint("Loaded ${_scannedItems.length} items for role: $currentRole");
        _isLoading.value = false;
        _errorMessage.value = '';
      } else {
        _errorMessage.value = 'Failed to load receipt: '
            '${resp.statusCode}\n${resp.body}';
        _isLoading.value = false;
      }
    } catch (e) {
      debugPrint("Error in fetchReceiptAndItems: $e");
      _errorMessage.value = 'Error fetching data: $e';
      _isLoading.value = false;
    }

    // Force UI update after completion
    update();
  }

  bool _hasUserSessionChanged(String? currentRole, int? currentUserId) {
    return _lastUserRole != currentRole || _lastUserId != currentUserId;
  }

  void _clearAllData() {
    debugPrint("Clearing all ScannedItemsController data");
    _scannedItems.clear();
    _isLoading.value = false;
    _errorMessage.value = '';
    _lastUserRole = null;
    _lastUserId = null;
    update();
  }

  Future<void> refreshData() async {
    await fetchReceiptAndItems();
  }

  @override
  void onClose() {
    debugPrint("ScannedItemsController onClose called");
    _clearAllData();
    super.onClose();
  }
}
