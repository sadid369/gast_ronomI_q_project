import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/presentation/screens/home/controller/home_controller.dart';
import 'package:groc_shopy/utils/logger/logger.dart';

import '../../../../core/routes/route_path.dart';
import '../../../../core/routes/routes.dart';
import '../../../../dependency_injection/path.dart';
import '../../../../global/model/user.dart';
import '../../../../helper/local_db/local_db.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../../../../service/check_api.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/static_strings/static_strings.dart';

class AuthController extends GetxController {
  // Rx<TextEditingController> fullNameController =
  //     TextEditingController(text: kDebugMode ? "Sadid" : "").obs;
  // Rx<TextEditingController> emailController =
  //     TextEditingController(text: kDebugMode ? "sadid.jones@gmail.com" : "")
  //         .obs;
  // Rx<TextEditingController> passController =
  //     TextEditingController(text: kDebugMode ? "123456Er" : "").obs;
  // Rx<TextEditingController> confirmController =
  //     TextEditingController(text: kDebugMode ? "123456Er" : "").obs;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController =
      TextEditingController(text: "sadid.jones@gmail.com").obs;
  Rx<TextEditingController> passController =
      TextEditingController(text: "123456Er").obs;
  Rx<TextEditingController> confirmController =
      TextEditingController(text: "123456Er").obs;

  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<bool> rememberMe = false.obs;
  Rx<bool> isAgree = false.obs;
  Rx<bool> isClient = true.obs;

  ApiClient apiClient = serviceLocator();
  final HomeController homeController = Get.find<HomeController>();

  /// =================== Save Info ===================
  String cleanUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('"', '').trim();
  }

  saveInformation({required Response<dynamic> response}) {
    // dbHelper.storeTokenUserdata(
    //     token: response.body["data"]["accessToken"],
    //     role: response.body["data"]["role"]);

    SharedPrefsHelper.setString(
        AppConstants.token, response.body["data"]["accessToken"]);
    SharedPrefsHelper.setString(
        AppConstants.userRole, response.body["data"]["role"]);
  }

  ///============================ Sign In =========================
  RxBool signInLoading = false.obs;

  signIn({required BuildContext context}) async {
    signInLoading.value = true;

    var body = {
      "email": emailController.value.text,
      "password": passController.value.text
    };
    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.signInClient.addBaseUrl,
    );

    if (response.statusCode == 200) {
      // debugPrint("Sign In Response: ${response.body.toString()}");
      // save desired fields
      await SharedPrefsHelper.setString(
          AppConstants.fullName, response.body["full_name"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.email, response.body["email"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.image, response.body["image"]?.toString() ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.token, response.body["access"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.userRole, response.body["role"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.refresh, response.body["refresh"] ?? "");
      await SharedPrefsHelper.setString("test", "admin");
      await SharedPrefsHelper.setInt(
          AppConstants.userID, response.body["id"] ?? 0);

      // Save credentials if rememberMe is true
      if (rememberMe.value) {
        await SharedPrefsHelper.setString(
            AppConstants.savedEmail, emailController.value.text);
        await SharedPrefsHelper.setString(
            AppConstants.savedPassword, passController.value.text);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        await SharedPrefsHelper.remove(AppConstants.savedEmail);
        await SharedPrefsHelper.remove(AppConstants.savedPassword);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, false);
      }

      AppRouter.route.pushReplacement(RoutePath.home.addBasePath);
    } else {
      // ignore: use_build_context_synchronously
      checkApi(response: response, context: context);
    }

    signInLoading.value = false;
    signInLoading.refresh();
  }

  RxBool employeeSignInLoading = false.obs;
  Future<void> employeeSignIn({required BuildContext context}) async {
    employeeSignInLoading.value = true;

    var body = {
      "email": emailController.value.text,
      "password": passController.value.text
    };
    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.employeeSignIn.addBaseUrl,
    );

    if (response.statusCode == 200) {
      // Save employee info from response
      await SharedPrefsHelper.setString(
          AppConstants.fullName, response.body["name"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.email, response.body["email"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.token, response.body["access"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.userRole, response.body["role"] ?? "");
      await SharedPrefsHelper.setString(
          AppConstants.refresh, response.body["refresh"] ?? "");
      await SharedPrefsHelper.setInt(
          AppConstants.userID, response.body["id"] ?? 0);
      await SharedPrefsHelper.setString(
          "designation", response.body["designation"] ?? "");
      await SharedPrefsHelper.setString("phone", response.body["phone"] ?? "");
      // Save image if present
      await SharedPrefsHelper.setString("test", "employee");
      await SharedPrefsHelper.setString(
          AppConstants.image, response.body["image"]?.toString() ?? "");

      // Save credentials if rememberMe is true
      if (rememberMe.value) {
        await SharedPrefsHelper.setString(
            AppConstants.savedEmail, emailController.value.text);
        await SharedPrefsHelper.setString(
            AppConstants.savedPassword, passController.value.text);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        await SharedPrefsHelper.remove(AppConstants.savedEmail);
        await SharedPrefsHelper.remove(AppConstants.savedPassword);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, false);
      }
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        await homeController.refreshAfterLogin();
      }
      context.pushReplacement(RoutePath.home.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    employeeSignInLoading.value = false;
    employeeSignInLoading.refresh();
  }

  ///============================ Sign Up =========================
  RxBool signUpLoading = false.obs;

  signup({required BuildContext context}) async {
    signUpLoading.value = true;

    // Create a User object using the controllers' text values
    User user = User(
      email: emailController.value.text,
      password: passController.value.text,
      rePassword: confirmController.value.text,
      fullName: fullNameController.value.text,
    );

    // Validate the user data using the validate method
    String validationMessage = user.validate();

    if (validationMessage != 'User data is valid') {
      // Show validation error (e.g., using a snackbar, dialog, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      signUpLoading.value = false;
      signUpLoading.refresh();
      return;
    }

    // If validation is successful, prepare the body for the API request
    var body = user.toJson();

    // Send the API request
    var response = await apiClient.post(
      body: body,
      isBasic: true,
      url: ApiUrl.signUpClient.addBaseUrl,
    );

    if (response.statusCode == 201) {
      // Redirect to login screen upon successful sign-in
      context.push(RoutePath.auth.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    signUpLoading.value = false;
    signUpLoading.refresh();
  }

  /// ====================== signUpOtpVarify ========================
  RxBool verifyLoading = false.obs;

  RxBool resetOtpLoading = false.obs;

  Future<void> sendResetOtp({
    required BuildContext context,
    required String email,
  }) async {
    resetOtpLoading.value = true;
    var body = {"email": email};
    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      // url: '/user/api/v1/send-reset-otp/'.addBaseUrl,
      url: ApiUrl.sendResetOtp.addBaseUrl,
      // url: "http://10.0.70.145:8001/user/api/v1/send-reset-otp/",
    );
    resetOtpLoading.value = false;

    if (response.statusCode == 200) {
      // on success navigate to verification screen
      context.push(RoutePath.verification.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

  RxBool verifyResetOtpLoading = false.obs;

  Future<void> verifyResetOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    verifyResetOtpLoading.value = true;
    final body = {"email": email, "otp": otp};
    final response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.verifyResetOtp.addBaseUrl,
      // url: "http://10.0.70.145:8001/user/api/v1/verify-reset-otp/",
    );
    verifyResetOtpLoading.value = false;

    if (response.statusCode == 200) {
      final resetToken = response.body["reset_token"];
      // save token in shared prefs
      await SharedPrefsHelper.setString(AppConstants.resetToken, resetToken);
      // navigate without passing extra
      context.push(RoutePath.resetPassConfirm.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

  RxBool setNewPasswordLoading = false.obs;

  Future<void> setNewPasswordAfterOtp({
    required BuildContext context,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    setNewPasswordLoading.value = true;
    final body = {
      "reset_token": resetToken,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };

    final response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.setNewPasswordAfterOtp.addBaseUrl,
      // url: "http://10.0.70.145:8001/user/api/v1/set-new-password-after-otp/",
    );

    setNewPasswordLoading.value = false;

    if (response.statusCode == 200) {
      // clear the stored reset token
      await SharedPrefsHelper.remove(AppConstants.resetToken);
      // Show success and navigate to success screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(response.body["message"] ?? "Password reset successful")),
      );
      context.push(RoutePath.resetPasswordSuccess.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

  Future<void> logout({required BuildContext context}) async {
    // Get tokens from shared preferences
    final refreshToken =
        await SharedPrefsHelper.getString(AppConstants.refresh);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      // Call the logout API
      final response = await apiClient.post(
        url: "http://10.0.70.145:8001/user/logout/",
        body: {"refresh": refreshToken},
        isBasic: false,
        showResult: true,
      );

      if (response.statusCode == 205) {
        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.body["detail"] ?? "Logout successful.")),
        );
      } else {
        // Optionally handle error
        checkApi(response: response, context: context);
      }
    }

    // Clear saved user data
    await SharedPrefsHelper.remove(AppConstants.token);
    await SharedPrefsHelper.remove(AppConstants.userRole);
    await SharedPrefsHelper.remove(AppConstants.fullName);
    await SharedPrefsHelper.remove(AppConstants.email);
    await SharedPrefsHelper.remove(AppConstants.image);
    await SharedPrefsHelper.remove(AppConstants.refresh);
    await SharedPrefsHelper.remove(AppConstants.userID);
    await SharedPrefsHelper.remove("test");
    // Navigate to login (replace the entire stack)
    context.pushReplacement(RoutePath.auth.addBasePath);
  }

  Future<void> loadSavedCredentials() async {
    final savedEmail =
        await SharedPrefsHelper.getString(AppConstants.savedEmail);
    final savedPassword =
        await SharedPrefsHelper.getString(AppConstants.savedPassword);
    final savedRememberMe =
        await SharedPrefsHelper.getBool(AppConstants.rememberMe) ?? false;

    if (savedRememberMe) {
      emailController.value.text = savedEmail ?? '';
      passController.value.text = savedPassword ?? '';
      rememberMe.value = true;
    }
  }
}
