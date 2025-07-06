import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/core/custom_assets/assets.gen.dart';
import 'package:groc_shopy/core/routes/route_path.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/local_db/local_db.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';
import 'controller/auth_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// Add these imports for Google Sign-In
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final AuthController _authController = Get.find<AuthController>();
  bool _isAdmin = true;
  bool _passwordVisible = false;

  // UI Constants
  static const double _horizontalPadding = 20;

  @override
  void initState() {
    super.initState();
    _authController.loadSavedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _horizontalPadding.w),
              child: Form(
                key: _authController.signInFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Gap(45.h),
                    _buildEmailField(),
                    Gap(35.h),
                    _buildPasswordField(),
                    Gap(6.73.h),
                    _isAdmin
                        ? _buildAdminOptions(context)
                        : _buildEmployeeOptions(),
                    // Only show social options for admin
                    if (_isAdmin) ...[
                      Gap(28.h),
                      _buildOrDivider(),
                      Gap(31.h),
                      _buildSocialSignInOptions(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _buildLogo(),
        Gap(15.h),
        _buildTitle(),
        Gap(25.h),
        _buildRoleTabs(),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      Assets.icons.logo.path,
      height: 70.h,
      width: 70.w,
    );
  }

  Widget _buildTitle() {
    return Text(
      AppStrings.signIn.tr,
      style: AppStyle.kohSantepheap18w700CFFD673,
    );
  }

  Widget _buildRoleTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleTab(AppStrings.employee.tr, !_isAdmin,
            () => setState(() => _isAdmin = false)),
        _buildRoleTab(AppStrings.admin.tr, _isAdmin,
            () => setState(() => _isAdmin = true)),
      ],
    );
  }

  Widget _buildRoleTab(String title, bool selected, VoidCallback onTap) {
    final color =
        selected ? AppColors.yellowFFD673 : AppColors.black50opacity80000000;
    final fontWeight = selected ? FontWeight.bold : FontWeight.normal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        width: 175.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppStyle.inter16w700C80000000.copyWith(
                fontWeight: fontWeight,
                color: color,
              ),
            ),
            Gap(12.h),
            Container(
              height: selected ? 4.h : 1.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _authController.emailController, // Remove .value
      labelText: AppStrings.email.tr,
      hintText: AppStrings.enterYourEmailHint.tr,
      suffixIcon: Icons.email_outlined,
      obscureText: false,
      validator: _authController.validateEmail,
      hintStyle: AppStyle.roboto14w500CB3B3B3,
      style: AppStyle.roboto16w500C545454,
      labelStyle: AppStyle.roboto14w500C000000,
      enabledBorderColor: AppColors.black30opacity4D000000,
      focusedBorderColor: AppColors.yellowFFD673,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => CustomTextFormField(
          controller: _authController.passController, // Remove .value
          labelText: AppStrings.password.tr,
          hintText: AppStrings.password.tr,
          suffixIcon: _authController.passwordVisible.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          obscureText: !_authController.passwordVisible.value,
          onSuffixIconTap: _authController.togglePasswordVisibility,
          validator: _authController.validatePassword,
          hintStyle: AppStyle.roboto14w500CB3B3B3,
          style: AppStyle.roboto16w500C545454,
          labelStyle: AppStyle.roboto14w500C000000,
          enabledBorderColor: AppColors.black30opacity4D000000,
          focusedBorderColor: AppColors.yellowFFD673,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
        ));
  }

  Widget _buildAdminOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildForgotPasswordLink(context),
        _buildRememberMeCheckbox(),
        Gap(33.h),
        _buildSignInButton(() => _authController.signIn(context: context)),
        Gap(15.h),
        _buildSignUpOption(context),
      ],
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => context.push(RoutePath.forgotPass.addBasePath),
        child: Text(
          AppStrings.forgotPassword.tr,
          style: AppStyle.roboto14w500CFFD673,
        ),
      ),
    );
  }

  Widget _buildEmployeeOptions() {
    return Column(
      children: [
        _buildRememberMeCheckbox(),
        Gap(33.h),
        _buildSignInButton(
            () => _authController.employeeSignIn(context: context)),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Obx(() => Row(
          children: [
            Checkbox(
              value: _authController.rememberMe.value,
              onChanged: (value) =>
                  _authController.rememberMe.value = value ?? false,
              activeColor: AppColors.yellowFFD673,
            ),
            Text(
              AppStrings.rememberMe.tr,
              style: AppStyle.roboto14w400C000000,
            ),
          ],
        ));
  }

  Widget _buildSignInButton(VoidCallback onPressed) {
    return Obx(() => AppButton(
          text: AppStrings.signIn.tr,
          onPressed: _isAdmin
              ? (_authController.signInLoading.value ? null : onPressed)
              : (_authController.employeeSignInLoading.value
                  ? null
                  : onPressed),
          width: double.infinity,
          height: 48.h,
          backgroundColor: AppColors.yellowFFD673,
          borderRadius: 8,
          textStyle: AppStyle.inter16w700CFFFFFF,
          isLoading: _isAdmin
              ? _authController.signInLoading.value
              : _authController.employeeSignInLoading.value,
        ));
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAAccount.tr,
          style: AppStyle.roboto14w400C000000,
        ),
        GestureDetector(
          onTap: () => context.push(RoutePath.adminSignUp.addBasePath),
          child: _buildUnderlinedText(AppStrings.signUp.tr),
        ),
      ],
    );
  }

  Widget _buildUnderlinedText(String text) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Text(
            text,
            style: AppStyle.roboto14w500CFFD673,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 2.h,
            color: AppColors.yellowFFD673,
          ),
        ),
      ],
    );
  }

  Widget _buildOrDivider() {
    return Text(
      AppStrings.or.tr,
      style: AppStyle.roboto14w500C80000000,
    );
  }

  Widget _buildSocialSignInOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => _authController.googleSignInLoading.value
            ? const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.yellowFFD673),
              )
            : _buildSocialIcon(
                iconPath: Assets.icons.google.path,
                onTap: _signInWithGoogle,
              )),
      ],
    );
  }

  Widget _buildSocialIcon({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(iconPath),
      ),
    );
  }

  // Event handlers
  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _signInWithApple() async {}

  void _signInWithGoogle() async {
    await _authController.signInWithGoogle(context: context);
  }

  // Helper method for safer message display
  void _showMessage(String message, {bool isSuccess = false}) {
    try {
      print('Showing message: $message');

      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: isSuccess ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        print('Context not available for showing snackbar');
      }
    } catch (e) {
      print('Error showing message: $e');
      print('Message was: $message');
    }
  }
}
