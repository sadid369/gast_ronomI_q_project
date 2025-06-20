import 'dart:convert';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/service/api_url.dart';
import '../../../../global/model/transaction_history.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';

class TransactionHistoryController extends GetxController {
  final history = Rxn<TransactionHistory>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final ApiClient _apiClient = serviceLocator<ApiClient>();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final resp = await _apiClient.get(
        url: ApiUrl.transaction.addBaseUrl,
        showResult: true,
      );

      if (resp.statusCode == 200) {
        final jsonBody = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());
        history.value = TransactionHistory.fromJson(jsonBody);
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
