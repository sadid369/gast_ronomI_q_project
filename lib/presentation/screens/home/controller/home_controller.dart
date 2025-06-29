import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import '../../../../global/language/controller/language_controller.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../service/api_url.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../transaction_history/controller/transaction_history_controller.dart';
import '../home_screen.dart';

class HomeController extends GetxController {
  // Make LanguageController optional to avoid dependency issues
  LanguageController? _langCtrl;

  /// Holds the recent items
  final RxList<RecentItem> items = <RecentItem>[].obs;

  /// Loading flag
  final RxBool loading = true.obs;

  final ApiClient _apiClient = serviceLocator<ApiClient>();

  // Make transaction controller optional to avoid dependency issues
  TransactionHistoryController? _transactionHistoryController;

  @override
  void onInit() {
    super.onInit();
    debugPrint("HomeController onInit - clearing existing data");

    // Initialize LanguageController if available
    if (Get.isRegistered<LanguageController>()) {
      _langCtrl = Get.find<LanguageController>();
    }

    // Always clear existing data first
    items.clear();
    loading.value = true;

    // Initialize transaction controller if available
    if (Get.isRegistered<TransactionHistoryController>()) {
      _transactionHistoryController = Get.find<TransactionHistoryController>();
    }

    // Fetch fresh data
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      debugPrint("Initializing fresh data for HomeController");
      await fetchRecentOrders();
    } catch (e) {
      debugPrint("Error initializing home data: $e");
      loading.value = false;
    }
  }

  Future<void> fetchRecentOrders() async {
    loading.value = true;
    items.clear(); // Always clear existing data first

    try {
      // Get user role from shared preferences
      final userRole =
          await SharedPrefsHelper.getString(AppConstants.userRole) ?? "";
      final userId = await SharedPrefsHelper.getInt(AppConstants.userID) ?? 0;

      debugPrint("Fetching orders for role: $userRole, userId: $userId");

      String apiUrl;

      if (userRole == "employee") {
        debugPrint("Fetching recent orders for employee role");
        apiUrl = "${ApiUrl.employeeRecentOrders}$userId".addBaseUrl;
      } else {
        debugPrint("Fetching recent orders for admin/client role");
        apiUrl = ApiUrl.lastScanInvoiceItems.addBaseUrl;
      }

      debugPrint("API URL: $apiUrl");

      final resp = await _apiClient.get(
        url: apiUrl,
        showResult: true,
      );

      debugPrint("API Response - Status: ${resp.statusCode}");

      if (resp.statusCode == 200) {
        final jsonBody = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());
        final order = RecentOrder.fromJson(jsonBody);
        items.assignAll(order.items);
        debugPrint("Loaded ${items.length} items for $userRole");
      } else {
        debugPrint("Error fetching recent orders: ${resp.statusCode}");
        debugPrint("Response body: ${resp.body}");
      }
    } catch (e) {
      debugPrint("Exception in fetchRecentOrders: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshAfterLogin() async {
    debugPrint("Refreshing data after login");
    loading.value = true;
    items.clear(); // Clear existing data

    try {
      await _transactionHistoryController?.fetchHistory();
      await fetchRecentOrders();
    } catch (e) {
      debugPrint("Error refreshing after login: $e");
    }
  }

  void changeLanguage(String code) {
    if (_langCtrl != null) {
      _langCtrl!.changeLanguage(code == 'en' ? 'English' : 'German');
    } else {
      debugPrint("LanguageController not available");
    }
  }

  @override
  void onClose() {
    debugPrint("HomeController onClose - clearing data");
    // Clean up when controller is disposed
    items.clear();
    super.onClose();
  }
}
