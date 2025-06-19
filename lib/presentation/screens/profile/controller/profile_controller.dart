import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../global/model/user_order_list.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = serviceLocator<ApiClient>();

  /// Profile image file
  final Rx<File?> profileImageFile = Rx<File?>(null);

  /// Loading flag for orders
  final RxBool isLoadingOrders = false.obs;

  /// User orders
  final RxList<Order> userOrders = <Order>[].obs;

  /// Tab state: false = Recent, true = All
  final RxBool isTotal = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    try {
      final resp = await _apiClient.get(
        url: 'http://10.0.70.145:8001/report/api/v1/user_order_list/?page=1',
        showResult: true,
      );
      if (resp.statusCode == 200) {
        final jsonBody = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());
        final response = UserOrderListResponse.fromJson(jsonBody);
        userOrders.assignAll(response.orders);
      } else {
        userOrders.clear();
        // Optionally handle error
      }
    } catch (e) {
      userOrders.clear();
      // Optionally handle error
    } finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImageFile.value = File(pickedFile.path);
    }
  }

  void setTab(bool total) {
    isTotal.value = total;
  }
}
