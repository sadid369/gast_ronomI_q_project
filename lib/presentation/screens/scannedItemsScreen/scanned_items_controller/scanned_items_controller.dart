// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:groc_shopy/presentation/screens/home/controller/home_controller.dart';
// import 'package:http/http.dart' as http;

// import '../../../../global/model/receipt_Item.dart';
// import '../scanned_items_screen.dart';

// class ScannedItemsController extends GetxController {
//   final _items = <ReceiptItem>[].obs;
//   final _loading = false.obs;
//   final _error = ''.obs;

//   List<ReceiptItem> get items => _items;
//   bool get isLoading => _loading.value;
//   String get error => _error.value;

//   final HomeController _homeCtrl = Get.find<HomeController>();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchReceiptAndItems();
//   }

//   Future<void> fetchReceiptAndItems() async {
//     _loading.value = true;
//     const token = 'RtRRXxJSqzdjQSyxQJ1N4uoPgoNm2Ms1okC8qFMWoBU';
//     final url = 'http://10.0.70.145:8001/report/orders/recent/';
//     try {
//       final resp = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//       if (resp.statusCode == 200) {
//         final data = json.decode(resp.body) as Map<String, dynamic>;
//         final date = data['created_at'] as String? ?? '';
//         final list = (data['items'] as List)
//             .map((e) => ReceiptItem.fromJson(e, date))
//             .toList();
//         _items.assignAll(list);
//         // now refresh home data too
//         await _homeCtrl.fetchRecentOrders();
//       } else {
//         _error.value = 'Error ${resp.statusCode}';
//       }
//     } catch (e) {
//       _error.value = e.toString();
//     }
//     _loading.value = false;
//   }
// }
