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
  final LanguageController _langCtrl = Get.find<LanguageController>();

  /// Holds the recent items
  final RxList<RecentItem> items = <RecentItem>[].obs;

  /// Loading flag
  final RxBool loading = true.obs;

  final ApiClient _apiClient = serviceLocator<ApiClient>();
  final TransactionHistoryController _transactionHistoryController =
      Get.find<TransactionHistoryController>();

  @override
  void onInit() {
    super.onInit();
    _transactionHistoryController.fetchHistory();
    fetchRecentOrders();
  }

  Future<void> fetchRecentOrders() async {
    loading.value = true;
    try {
      // Get user role from shared preferences
      final userRole =
          await SharedPrefsHelper.getString(AppConstants.userRole) ?? "";

      String apiUrl;

      if (userRole.toLowerCase() == "employee") {
        debugPrint("Fetching recent orders for employee role");
        // Get user ID for employee endpoint
        final userId = await SharedPrefsHelper.getInt(AppConstants.userID) ?? 0;
        apiUrl = "${ApiUrl.employeeRecentOrders}$userId".addBaseUrl;
      } else {
        // Default to admin/user endpoint
        apiUrl = ApiUrl.lastScanInvoiceItems.addBaseUrl;
      }

      final resp = await _apiClient.get(
        url: apiUrl,
        showResult: true,
      );

      if (resp.statusCode == 200) {
        final jsonBody = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());
        final order = RecentOrder.fromJson(jsonBody);
        items.assignAll(order.items);
      } else {
        // TODO: error handling
        print("Error fetching recent orders: ${resp.statusCode}");
      }
    } catch (e) {
      // TODO: exception handling
      print("Exception in fetchRecentOrders: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshAfterLogin() async {
    await _transactionHistoryController.fetchHistory();
    await fetchRecentOrders();
  }

  void changeLanguage(String code) {
    _langCtrl.changeLanguage(code == 'en' ? 'English' : 'German');
  }
}
