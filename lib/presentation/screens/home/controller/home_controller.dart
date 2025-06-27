import 'dart:convert';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import '../../../../global/language/controller/language_controller.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../service/api_url.dart';
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
      final resp = await _apiClient.get(
        url: ApiUrl.lastScanInvoiceItems.addBaseUrl,
        // url: 'http://10.0.70.145:8001/report/orders/recent/',
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
      }
    } catch (e) {
      // TODO: exception handling
    } finally {
      loading.value = false;
    }
  }

  void changeLanguage(String code) {
    _langCtrl.changeLanguage(code == 'en' ? 'English' : 'German');
  }
}
