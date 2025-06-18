import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../global/language/controller/language_controller.dart';

import '../home_screen.dart';

class HomeController extends GetxController {
  final LanguageController _langCtrl = Get.find<LanguageController>();

  /// Holds the recent items
  final RxList<RecentItem> items = <RecentItem>[].obs;

  /// Loading flag
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentOrders();
  }

  Future<void> fetchRecentOrders() async {
    loading.value = true;
    try {
      final resp = await http.get(
        Uri.parse('http://10.0.70.145:8001/report/orders/recent/'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNzk4Mjg3LCJpYXQiOjE3NTAyMDYyODcsImp0aSI6IjU4ZjZlNWZmYmUzZDRjN2VhNTA0NGE5NmI5MWNjMTEyIiwidXNlcl9pZCI6NjF9.g7CJStsIGf_nMQsVdjLJmiilcC59jnq5yloneCB0K7Q',
        },
      );
      if (resp.statusCode == 200) {
        final jsonBody = json.decode(resp.body);
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
    // pass full locale name into your existing language controller
    _langCtrl.changeLanguage(code == 'en' ? 'English' : 'German');
  }
}
