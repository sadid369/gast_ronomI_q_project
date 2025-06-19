import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';

class ReportController extends GetxController {
  final ApiClient _apiClient = serviceLocator<ApiClient>();

  final RxInt displayedYear = DateTime.now().year.obs;
  final RxInt displayedMonth = DateTime.now().month.obs;

  final RxBool isLoading = false.obs;
  final RxMap<String, double> dataMap = <String, double>{}.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    dataMap.clear();

    try {
      final resp = await _apiClient.get(
        url:
            'http://10.0.70.145:8001/report/reports/monthly/${displayedYear.value}/${displayedMonth.value}/',
        showResult: true,
      );

      if (resp.statusCode == 200) {
        final responseData = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());

        final Map<String, double> safeDataMap = {};
        if (responseData['spending_by_category'] != null) {
          responseData['spending_by_category'].forEach((key, value) {
            safeDataMap[key] =
                (value is int) ? value.toDouble() : value as double;
          });
        }
        dataMap.assignAll(safeDataMap);
      } else {
        errorMessage.value = 'Failed to load data: ${resp.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goToPreviousMonth() {
    if (displayedMonth.value == 1) {
      displayedMonth.value = 12;
      displayedYear.value--;
    } else {
      displayedMonth.value--;
    }
    fetchData();
  }

  void goToNextMonth() {
    if (displayedMonth.value == 12) {
      displayedMonth.value = 1;
      displayedYear.value++;
    } else {
      displayedMonth.value++;
    }
    fetchData();
  }
}
