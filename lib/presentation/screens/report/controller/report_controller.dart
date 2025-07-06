import 'dart:convert';
import 'package:get/get.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../helper/extension/base_extension.dart';

class ReportController extends GetxController {
  final ApiClient _apiClient = serviceLocator<ApiClient>();

  final RxInt displayedYear = DateTime.now().year.obs;
  final RxInt displayedMonth = DateTime.now().month.obs;

  final RxBool isLoading = false.obs;
  final RxMap<String, double> dataMap = <String, double>{}.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    dataMap.clear();

    try {
      final resp = await _apiClient.get(
        url: ApiUrl.monthlyReport(displayedYear.value, displayedMonth.value)
            .addBaseUrl,
        showResult: true,
      );

      if (resp.statusCode == 200) {
        final responseData = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());

        final Map<String, double> safeDataMap = {};

        // Handle different possible response structures
        if (responseData['data'] != null &&
            responseData['data']['spending_by_category'] != null) {
          responseData['data']['spending_by_category'].forEach((key, value) {
            safeDataMap[key] = _convertToDouble(value);
          });
        } else if (responseData['spending_by_category'] != null) {
          responseData['spending_by_category'].forEach((key, value) {
            safeDataMap[key] = _convertToDouble(value);
          });
        } else {
          errorMessage.value = 'No spending data found for this period';
        }

        dataMap.assignAll(safeDataMap);
      } else {
        errorMessage.value = 'Failed to load data: ${resp.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data: $e';
      print('ReportController Error: $e'); // Debug log
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to safely convert values to double
  double _convertToDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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

  // Helper method to get month name
  String get currentMonthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[displayedMonth.value - 1];
  }

  // Helper method to check if we can go to next month (not future)
  bool get canGoToNextMonth {
    final now = DateTime.now();
    if (displayedYear.value < now.year) return true;
    if (displayedYear.value == now.year && displayedMonth.value < now.month)
      return true;
    return false;
  }

  // Method to refresh data
  Future<void> refreshData() async {
    await fetchData();
  }
}
