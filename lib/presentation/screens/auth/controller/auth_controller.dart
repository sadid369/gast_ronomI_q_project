import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';

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
  Rx<TextEditingController> fullNameController =
      TextEditingController(text: kDebugMode ? "Sadid" : "").obs;
  Rx<TextEditingController> emailController =
      TextEditingController(text: kDebugMode ? "sadid.jones@gmail.com" : "")
          .obs;
  Rx<TextEditingController> passController =
      TextEditingController(text: kDebugMode ? "1234567Rr" : "").obs;
  Rx<TextEditingController> confirmController =
      TextEditingController(text: kDebugMode ? "1234567Rr" : "").obs;

  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<bool> rememberMe = false.obs;
  Rx<bool> isAgree = false.obs;
  Rx<bool> isClient = true.obs;

  ApiClient apiClient = serviceLocator();

  /// =================== Save Info ===================

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
        url: ApiUrl.signInClient.addBaseUrl);

    // // Ensure the widget is still mounted before using BuildContext
    // if (!context.mounted) return;

    // if (response.statusCode == 200) {
    //   saveInformation(response: response);
    //   if (response.body["data"]["role"] == AppConstants.admin) {
    //   } else {
    //     AppRouter.route.replaceNamed(RoutePath.workerHome);
    //   }
    if (response.statusCode == 200) {
      AppRouter.route.pushReplacement(RoutePath.home.addBasePath);
    } else {
      // ignore: use_build_context_synchronously
      checkApi(response: response, context: context);
    }

    signInLoading.value = false;
    signInLoading.refresh();
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

    if (response.statusCode == 200) {
      // Redirect to login screen upon successful sign-in
      context.pushNamed(RoutePath.login.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    signUpLoading.value = false;
    signUpLoading.refresh();
  }

  /// ====================== signUpOtpVarify ========================
  RxBool verifyLoading = false.obs;

  // signUpOtpVerify({required BuildContext context}) async {
  //   verifyLoading.value = true;
  //   var body = {
  //     "email": emailController.value.text,
  //     "activation_code": otpController.value.text
  //   };

  //   var response = await apiClient.patch(
  //       body: body,
  //       isBasic: true,
  //       showResult: true,
  //       url: isClient.value
  //           ? ApiUrl.activeClient.addBaseUrl
  //           : ApiUrl.activeWorker.addBaseUrl);

  //   if (response.statusCode == 201) {
  //     timer.cancel();
  //     showSnackBar(
  //         // ignore: use_build_context_synchronously
  //         context: context,
  //         content: response.body["message"],
  //         backgroundColor: Colors.green);

  //     AppRouter.route.pushReplacementNamed(
  //       RoutePath.login,
  //     );
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     checkApi(response: response, context: context);
  //   }

  //   verifyLoading.value = false;
  // }

  // ======================== Timer ====================

  // RxInt secondsRemaining = 60.obs;
  // late Timer timer;

  // void startTimer() {
  //   debugPrint("resend OTP Timer -------->>>>>>>>> $secondsRemaining");
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (secondsRemaining.value > 0) {
  //       secondsRemaining.value--;
  //       secondsRemaining.refresh();
  //       debugPrint("resend OTP Timer -------->>>>>>>>> $secondsRemaining");
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  /// ===================== Resent OTP ======================

  // Future<bool> resendOTP() async {
  //   var body = {"email": emailController.value.text};

  //   var response = await apiClient.patch(
  //       isBasic: true,
  //       body: body,
  //       url: isClient.value
  //           ? ApiUrl.resendOTpClient.addBaseUrl
  //           : ApiUrl.resendOTpWorker.addBaseUrl);

  //   if (response.statusCode == 200) {
  //     secondsRemaining.value = 60;
  //     secondsRemaining.refresh();
  //     startTimer();

  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
