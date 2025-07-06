import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/presentation/screens/home/controller/home_controller.dart';
import 'package:groc_shopy/utils/logger/logger.dart';
// Updated import
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
import '../../profile/controller/profile_controller.dart';
import '../../scannedItemsScreen/controller/scanned_items_controller.dart';
import '../../transaction_history/controller/transaction_history_controller.dart';

class AuthController extends GetxController {
  // Text Controllers - Remove Rx wrapper to prevent disposal issues
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(text: "sadid.jones@gmail.com");
  final TextEditingController passController =
      TextEditingController(text: "123456Er");
  final TextEditingController confirmController =
      TextEditingController(text: "123456Er");
  final TextEditingController otpController = TextEditingController();

  // Form Keys for validation
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> setPasswordFormKey = GlobalKey<FormState>();

  // Observable variables
  Rx<bool> rememberMe = false.obs;
  Rx<bool> isAgree = false.obs;
  Rx<bool> isClient = true.obs;
  Rx<bool> passwordVisible = false.obs;
  Rx<bool> confirmPasswordVisible = false.obs;

  // Loading states
  RxBool signInLoading = false.obs;
  RxBool employeeSignInLoading = false.obs;
  RxBool signUpLoading = false.obs;
  RxBool verifyLoading = false.obs;
  RxBool resetOtpLoading = false.obs;
  RxBool verifyResetOtpLoading = false.obs;
  RxBool setNewPasswordLoading = false.obs;
  RxBool googleSignInLoading = false.obs;

  ApiClient apiClient = serviceLocator();
  bool _isDisposed = false; // Add disposal tracking

  @override
  void onInit() {
    super.onInit();
    loadSavedCredentials();
  }

  @override
  void onClose() {
    _isDisposed = true;
    try {
      fullNameController.dispose();
      emailController.dispose();
      passController.dispose();
      confirmController.dispose();
      otpController.dispose();
    } catch (e) {
      debugPrint("Error disposing controllers: $e");
    }
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    if (!_isDisposed) {
      passwordVisible.value = !passwordVisible.value;
    }
  }

  void toggleConfirmPasswordVisibility() {
    if (!_isDisposed) {
      confirmPasswordVisible.value = !confirmPasswordVisible.value;
    }
  }

  // Validation methods
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fullNameRequired.tr;
    }
    if (value.trim().length < 2) {
      return AppStrings.fullNameMinLength.tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired.tr;
    }
    if (!AppStrings.emailRegexp.hasMatch(value.trim())) {
      return AppStrings.enterValidEmail.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired.tr;
    }
    if (!AppStrings.passwordRegex.hasMatch(value)) {
      return AppStrings.passWordMustBeAtLeast.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired.tr;
    }
    if (value != passController.text) {
      return AppStrings.passwordsDoNotMatch.tr;
    }
    return null;
  }

  // Show awesome snackbar using awesome_snackbar_content package
  void _showAwesomeSnackbar(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// =================== Save Info ===================
  String cleanUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('"', '').trim();
  }

  saveInformation({required Response<dynamic> response}) {
    SharedPrefsHelper.setString(
        AppConstants.token, response.body["data"]["accessToken"]);
    SharedPrefsHelper.setString(
        AppConstants.userRole, response.body["data"]["role"]);
  }

  ///============================ Sign In =========================
  signIn({required BuildContext context}) async {
    if (signInLoading.value) return;

    if (!signInFormKey.currentState!.validate()) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.pleaseFixErrors.tr,
        contentType: ContentType.failure,
      );
      return;
    }

    signInLoading.value = true;

    var body = {
      "email": emailController.text.trim(),
      "password": passController.text
    };

    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.signInClient.addBaseUrl,
    );

    if (response.statusCode == 200) {
      await _clearAllUserData();

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

      if (rememberMe.value) {
        await SharedPrefsHelper.setString(
            AppConstants.savedEmail, emailController.text);
        await SharedPrefsHelper.setString(
            AppConstants.savedPassword, passController.text);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        await SharedPrefsHelper.remove(AppConstants.savedEmail);
        await SharedPrefsHelper.remove(AppConstants.savedPassword);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, false);
      }

      _showAwesomeSnackbar(
        context,
        title: AppStrings.welcomeTitle.tr,
        message: AppStrings.adminLoginSuccessful.tr,
        contentType: ContentType.success,
      );

      // Use delay to allow snackbar to show before navigation
      await Future.delayed(const Duration(milliseconds: 500));
      AppRouter.route.pushReplacement(RoutePath.home.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    signInLoading.value = false;
  }

  ///============================ Employee Sign In =========================
  Future<void> employeeSignIn({required BuildContext context}) async {
    if (employeeSignInLoading.value) return;

    if (!signInFormKey.currentState!.validate()) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.pleaseFixErrors.tr,
        contentType: ContentType.failure,
      );
      return;
    }

    employeeSignInLoading.value = true;

    var body = {
      "email": emailController.text.trim(),
      "password": passController.text
    };

    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.employeeSignIn.addBaseUrl,
    );

    if (response.statusCode == 200) {
      await _clearAllUserData();

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
      await SharedPrefsHelper.setString("test", "employee");
      await SharedPrefsHelper.setString(
          AppConstants.image, response.body["image"]?.toString() ?? "");

      if (rememberMe.value) {
        await SharedPrefsHelper.setString(
            AppConstants.savedEmail, emailController.text);
        await SharedPrefsHelper.setString(
            AppConstants.savedPassword, passController.text);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        await SharedPrefsHelper.remove(AppConstants.savedEmail);
        await SharedPrefsHelper.remove(AppConstants.savedPassword);
        await SharedPrefsHelper.setBool(AppConstants.rememberMe, false);
      }

      _showAwesomeSnackbar(
        context,
        title: AppStrings.welcomeTitle.tr,
        message: AppStrings.userLoginSuccessful.tr,
        contentType: ContentType.success,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      context.pushReplacement(RoutePath.home.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    employeeSignInLoading.value = false;
  }

  ///============================ Sign Up =========================
  signup({required BuildContext context}) async {
    if (signUpLoading.value) return;

    if (!signUpFormKey.currentState!.validate()) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.pleaseFixErrors.tr,
        contentType: ContentType.failure,
      );
      return;
    }

    signUpLoading.value = true;

    User user = User(
      email: emailController.text.trim(), // Remove .value
      password: passController.text, // Remove .value
      rePassword: confirmController.text, // Remove .value
      fullName: fullNameController.text.trim(), // Remove .value
    );

    String validationMessage = user.validate();

    if (validationMessage != 'User data is valid') {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: validationMessage,
        contentType: ContentType.failure,
      );
      signUpLoading.value = false;
      return;
    }

    var body = user.toJson();

    var response = await apiClient.post(
      body: body,
      isBasic: true,
      url: ApiUrl.signUpClient.addBaseUrl,
    );

    if (response.statusCode == 201) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.success.tr,
        message: AppStrings.accountCreatedSuccessfully.tr,
        contentType: ContentType.success,
      );
      context.push(RoutePath.auth.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }

    signUpLoading.value = false;
  }

  ///============================ Reset Password =========================
  Future<void> sendResetOtp({
    required BuildContext context,
    required String email,
  }) async {
    if (resetOtpLoading.value) return;

    // Validate email
    if (email.trim().isEmpty) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.emailRequired.tr,
        contentType: ContentType.warning,
      );
      return;
    }

    if (!AppStrings.emailRegexp.hasMatch(email.trim())) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.enterValidEmail.tr,
        contentType: ContentType.warning,
      );
      return;
    }

    resetOtpLoading.value = true;
    var body = {"email": email.trim()};
    var response = await apiClient.post(
      showResult: true,
      body: body,
      isBasic: true,
      url: ApiUrl.sendResetOtp.addBaseUrl,
    );
    resetOtpLoading.value = false;

    if (response.statusCode == 200) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.success.tr,
        message: AppStrings.passwordResetLinkSent.tr,
        contentType: ContentType.success,
      );
      context.push(RoutePath.verification.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

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
    );
    verifyResetOtpLoading.value = false;

    if (response.statusCode == 200) {
      final resetToken = response.body["reset_token"];
      await SharedPrefsHelper.setString(AppConstants.resetToken, resetToken);
      context.push(RoutePath.resetPassConfirm.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

  Future<void> setNewPasswordAfterOtp({
    required BuildContext context,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (setNewPasswordLoading.value) return;

    if (!setPasswordFormKey.currentState!.validate()) {
      _showAwesomeSnackbar(
        context,
        title: AppStrings.validationError.tr,
        message: AppStrings.pleaseFixErrors.tr,
        contentType: ContentType.failure,
      );
      return;
    }

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
    );

    setNewPasswordLoading.value = false;

    if (response.statusCode == 200) {
      await SharedPrefsHelper.remove(AppConstants.resetToken);
      _showAwesomeSnackbar(
        context,
        title: AppStrings.success.tr,
        message: response.body["message"] ?? "Password reset successful",
        contentType: ContentType.success,
      );
      context.push(RoutePath.resetPasswordSuccess.addBasePath);
    } else {
      checkApi(response: response, context: context);
    }
  }

  ///============================ Logout =========================
  Future<void> logout({required BuildContext context}) async {
    final refreshToken =
        await SharedPrefsHelper.getString(AppConstants.refresh);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      final response = await apiClient.post(
        url: ApiUrl.logout.addBaseUrl,
        body: {"refresh": refreshToken},
        isBasic: false,
        showResult: true,
      );

      if (response.statusCode == 205) {
        _showAwesomeSnackbar(
          context,
          title: AppStrings.success.tr,
          message: response.body["detail"] ?? "Logout successful.",
          contentType: ContentType.success,
        );
      } else {
        checkApi(response: response, context: context);
      }
    }

    await _clearAllUserData();
    context.pushReplacement(RoutePath.auth.addBasePath);
  }

  Future<void> _clearAllUserData() async {
    try {
      await SharedPrefsHelper.remove(AppConstants.token);
      await SharedPrefsHelper.remove(AppConstants.userRole);
      await SharedPrefsHelper.remove(AppConstants.fullName);
      await SharedPrefsHelper.remove(AppConstants.email);
      await SharedPrefsHelper.remove(AppConstants.image);
      await SharedPrefsHelper.remove(AppConstants.refresh);
      await SharedPrefsHelper.remove(AppConstants.userID);
      await SharedPrefsHelper.remove("test");
      await SharedPrefsHelper.remove("designation");
      await SharedPrefsHelper.remove("phone");

      debugPrint("All user data cleared from SharedPreferences");
    } catch (e) {
      debugPrint("Error clearing user data: $e");
    }
  }

  Future<void> loadSavedCredentials() async {
    final savedEmail =
        await SharedPrefsHelper.getString(AppConstants.savedEmail);
    final savedPassword =
        await SharedPrefsHelper.getString(AppConstants.savedPassword);
    final savedRememberMe =
        await SharedPrefsHelper.getBool(AppConstants.rememberMe) ?? false;

    if (savedRememberMe && !_isDisposed) {
      emailController.text = savedEmail ?? '';
      passController.text = savedPassword ?? '';
      rememberMe.value = true;
    }
  }

  ///============================ Google Sign In =========================
  Future<void> signInWithGoogle({required BuildContext context}) async {
    googleSignInLoading.value = true;

    try {
      debugPrint('=== Google Sign-In Controller Method ===');

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
            '418880569981-1ibh3bv48t8c8tla9cudp6o5q59elg0i.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      debugPrint('Google User: $googleUser');

      if (googleUser == null) {
        debugPrint('User cancelled Google Sign-In');
        _showAwesomeSnackbar(
          context,
          title: AppStrings.info.tr,
          message: 'Google sign-in was cancelled',
          contentType: ContentType.warning,
        );
        return;
      }

      debugPrint('SUCCESS: Google User obtained: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Failed to get access token from Google');
      }

      debugPrint('Sending Google token to backend...');
      Response response = await apiClient.post(
        showResult: true,
        body: {'access_token': accessToken},
        isBasic: true,
        url: ApiUrl.googleAuth.addBaseUrl,
        duration: 30,
      );

      debugPrint('Backend Response Status: ${response.statusCode}');
      debugPrint('Backend Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear user data but don't reset app state aggressively
        await _clearAllUserData();

        await SharedPrefsHelper.setString(
            AppConstants.fullName,
            response.body["full_name"] ??
                '${response.body["first_name"] ?? ""} ${response.body["last_name"] ?? ""}'
                    .trim());

        await SharedPrefsHelper.setString(
            AppConstants.email, response.body["email"] ?? googleUser.email);

        await SharedPrefsHelper.setString(AppConstants.image,
            response.body["image"]?.toString() ?? googleUser.photoUrl ?? "");

        await SharedPrefsHelper.setString(
            AppConstants.token, response.body["access"] ?? "");

        await SharedPrefsHelper.setString(
            AppConstants.userRole, response.body["role"] ?? "user");

        await SharedPrefsHelper.setString(
            AppConstants.refresh, response.body["refresh"] ?? "");

        await SharedPrefsHelper.setInt(
            AppConstants.userID, response.body["id"] ?? 0);

        await SharedPrefsHelper.setString(
            "test", response.body["role"] == "admin" ? "admin" : "user");

        debugPrint("Google login successful, navigating to home...");

        final userName = response.body["full_name"] ??
            '${response.body["first_name"] ?? ""} ${response.body["last_name"] ?? ""}'
                .trim();

        _showAwesomeSnackbar(
          context,
          title: AppStrings.welcomeTitle.tr,
          message:
              'Welcome ${userName.isNotEmpty ? userName : googleUser.displayName ?? 'User'}!',
          contentType: ContentType.success,
        );

        // Add delay and navigate without destroying controllers
        await Future.delayed(const Duration(milliseconds: 500));
        AppRouter.route.pushReplacement(RoutePath.home.addBasePath);
      } else {
        checkApi(response: response, context: context);
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');

      String errorMessage = e.toString();
      if (errorMessage.contains('network') ||
          errorMessage.contains('ClientException')) {
        errorMessage = 'Network error: Please check your connection';
      } else if (errorMessage.contains('PlatformException')) {
        errorMessage = 'Google Sign-In not available on this device';
      } else if (errorMessage.contains('sign_in_canceled')) {
        errorMessage = 'Sign-in was cancelled';
      } else {
        errorMessage = 'Google sign-in failed: Please try again';
      }

      _showAwesomeSnackbar(
        context,
        title: AppStrings.error.tr,
        message: errorMessage,
        contentType: ContentType.failure,
      );
    } finally {
      googleSignInLoading.value = false;
    }
  }
}
