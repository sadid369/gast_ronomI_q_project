import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/service/api_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Add this import
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
  final RxString name = ''.obs;
  final RxString role = ''.obs;
  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    fetchOrders(reset: true);
  }

  Future<void> loadProfile() async {
    final url = await SharedPrefsHelper.getString(AppConstants.image);
    final _name = await SharedPrefsHelper.getString(AppConstants.fullName);
    final _role = await SharedPrefsHelper.getString(AppConstants.userRole);
    // log('Profile image URL: $url');
    profileImageUrl.value = url.addBaseUrl ?? '';
    name.value = _name ?? '';
    role.value = _role == "ADMIN" ? 'Manager' : _role ?? 'Employee';
  }

  String cleanUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('"', '').trim();
  }

  Future<void> fetchOrders({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _totalPages = 1;
      userOrders.clear();
    }
    isLoadingOrders.value = true;
    try {
      final role = await SharedPrefsHelper.getString(AppConstants.userRole);
      final userId = await SharedPrefsHelper.getInt(AppConstants.userID);

      String url;
      if (role?.toLowerCase() == "employee" && userId != null) {
        url = ApiUrl.employeeOrderListWithId(userId, _currentPage);
      } else {
        url = '${ApiUrl.transactionWithInvoicImage.addBaseUrl}$_currentPage';
      }

      final resp = await _apiClient.get(
        url: url,
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
      File file = File(pickedFile.path);

      // Fix orientation
      final bytes = await file.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      final fixedImage = img.bakeOrientation(originalImage!);
      final fixedFile = await file.writeAsBytes(img.encodeJpg(fixedImage));

      profileImageFile.value = fixedFile;
      await uploadProfileImage(fixedFile);
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

    final _role = await SharedPrefsHelper.getString(AppConstants.userRole);

    // Use API URLs from ApiUrl class
    final String endpoint = _role == "employee"
        ? ApiUrl.employeeImageUpload(userId)
        : ApiUrl.adminImageUpload(userId);

    final url = Uri.parse(endpoint.addBaseUrl);

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final imagePath = respStr;
        // Adjust this if your API returns JSON
        await SharedPrefsHelper.setString(AppConstants.image, imagePath);
        profileImageUrl.value = cleanUrl(imagePath.addBaseUrl);
        Get.snackbar('Success', 'Profile image updated!');
      } else {
        Get.snackbar('Error', 'Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
    }
  }
}
