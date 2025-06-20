import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/service/api_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../../global/model/user_order_list.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../utils/app_const/app_const.dart';

class ProfileController extends GetxController {
  final ApiClient _apiClient = serviceLocator<ApiClient>();

  final Rx<File?> profileImageFile = Rx<File?>(null);
  final RxBool isLoadingOrders = false.obs;
  final RxList<Order> userOrders = <Order>[].obs;
  final RxBool isTotal = false.obs;
  final RxString profileImageUrl = ''.obs;
  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfileImageUrl();
    fetchOrders(reset: true);
  }

  Future<void> loadProfileImageUrl() async {
    final url = await SharedPrefsHelper.getString(AppConstants.image);
    profileImageUrl.value = url.addBaseUrl ?? '';
  }

  Future<void> fetchOrders({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _totalPages = 1;
      userOrders.clear();
    }
    isLoadingOrders.value = true;
    try {
      final resp = await _apiClient.get(
        url: '${ApiUrl.transactionWithInvoicImage.addBaseUrl}$_currentPage',
        showResult: true,
      );
      if (resp.statusCode == 200) {
        final jsonBody = resp.body is Map<String, dynamic>
            ? resp.body
            : json.decode(resp.body.toString());
        final response = UserOrderListResponse.fromJson(jsonBody);
        _totalPages = response.totalPages;
        if (_currentPage == 1) {
          userOrders.assignAll(response.orders);
        } else {
          userOrders.addAll(response.orders);
        }
      } else {
        if (_currentPage == 1) userOrders.clear();
      }
    } catch (e) {
      if (_currentPage == 1) userOrders.clear();
    } finally {
      isLoadingOrders.value = false;
      _isFetchingMore = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingMore || _currentPage >= _totalPages) return;
    _isFetchingMore = true;
    _currentPage++;
    await fetchOrders();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImageFile.value = File(pickedFile.path);
      await uploadProfileImage(profileImageFile.value!);
    }
  }

  void setTab(bool total) {
    isTotal.value = total;
    fetchOrders(reset: true);
  }

  Future<void> uploadProfileImage(File imageFile) async {
    final userId = await SharedPrefsHelper.getInt(AppConstants.userID);
    final token = await SharedPrefsHelper.getString(AppConstants.token);

    if (userId == null || token == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    final url = Uri.parse(
        'http://10.0.70.145:8001/user/api/v1/user/uploadimage/$userId/');
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final imagePath = respStr; // Adjust this if your API returns JSON
      await SharedPrefsHelper.setString(AppConstants.image, imagePath);
      profileImageUrl.value = imagePath.addBaseUrl;
      Get.snackbar('Success', 'Profile image updated!');
    } else {
      Get.snackbar('Error', 'Failed to upload image');
    }
  }
}
