import 'dart:io';
import 'package:flutter/material.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../service/api_service.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../core/routes/route_path.dart';
import '../../../../service/api_url.dart';
import '../../../../utils/app_const/app_const.dart';

class ScanController extends ChangeNotifier {
  final ApiClient _apiClient = serviceLocator();

  File? pickedImage;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  // final String _scanReceiptUrl =
  //     'http://10.0.70.145:8001/receipt/scan-receipt/';

  Future<void> pickImage(BuildContext context) async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) await _processAndNavigate(context, File(file.path));
  }

  Future<void> takePicture(BuildContext context) async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) await _processAndNavigate(context, File(file.path));
  }

  Future<void> _processAndNavigate(BuildContext context, File imageFile) async {
    pickedImage = imageFile;
    isLoading = true;
    notifyListeners();

    try {
      // Get user role and id
      final role = await SharedPrefsHelper.getString(AppConstants.userRole);
      final userId = await SharedPrefsHelper.getInt(AppConstants.userID);

      String url;
      if (role == "employee" && userId != null) {
        debugPrint("User role with ID: $userId");
        url = ApiUrl.employeeScanReceipt(userId);
      } else {
        url = "${ApiUrl.baseUrl}${ApiUrl.scanReceipt}";
      }

      final resp = await _apiClient.multipartRequest(
        url: url,
        reqType: 'POST',
        multipartBody: [MultipartBody('receipt', imageFile)],
      );

      if (resp.statusCode == 201) {
        // Use GoRouter for navigation
        if (context.mounted) {
          context.pushNamed(
            RoutePath.scannedItemsScreen,
            extra: {
              'image': imageFile,
              'scanSuccess': true,
              'apiResponse': resp.body,
            },
          );
        }
      } else {
        _showError(context, 'Failed (${resp.statusCode}): ${resp.body}');
      }
    } catch (e) {
      _showError(context, 'Upload error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}
