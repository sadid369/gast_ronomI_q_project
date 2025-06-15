import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/core/custom_assets/assets.gen.dart';
import 'package:groc_shopy/core/routes/route_path.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';
import 'controller/auth_controller.dart';

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  AdminSignUpScreenState createState() => AdminSignUpScreenState();
}

class AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final AuthController _authController = Get.find<AuthController>();
  bool _rememberMe = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(),
                    Gap(16.h),
                    _buildTitle(),
                    Gap(24.h),
                    _buildDivider(),
                    Gap(42.h),
                    _buildFullNameField(),
                    Gap(35.h),
                    _buildEmailField(),
                    Gap(35.h),
                    _buildPasswordField(),
                    Gap(35.h),
                    _buildConfirmPasswordField(),
                    _buildRememberMeCheckbox(),
                    Gap(33.h),
                    _buildSignUpButton(context),
                    Gap(15.h),
                    _buildSignInOption(context),
                    Gap(12.w),
                    _buildOrDivider(),
                    Gap(12.h),
                    _buildSocialSignInOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
      AppStrings.adminSignUp.tr,
      style: AppStyle.kohSantepheap18w700CFFD673,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        color: AppColors.black50opacity80000000,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildFullNameField() {
    return CustomTextFormField(
      controller: _authController.fullNameController.value,
      labelText: AppStrings.fullName.tr,
      hintText: AppStrings.enterYourFullName.tr,
      suffixIcon: Icons.person_outline,
      obscureText: false,
      hintStyle: AppStyle.roboto14w500CB3B3B3,
      style: AppStyle.roboto16w500C545454,
      labelStyle: AppStyle.roboto14w500C000000,
      enabledBorderColor: AppColors.black30opacity4D000000,
      focusedBorderColor: AppColors.yellowFFD673,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormField(
      controller: _authController.emailController.value,
      labelText: AppStrings.email.tr,
      hintText: AppStrings.enterYourEmailHint.tr,
      suffixIcon: Icons.email_outlined,
      obscureText: false,
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
    return CustomTextFormField(
      controller: _authController.passController.value,
      labelText: AppStrings.password.tr,
      hintText: AppStrings.password.tr,
      suffixIcon: _passwordVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      obscureText: !_passwordVisible,
      onSuffixIconTap: _togglePasswordVisibility,
      hintStyle: AppStyle.roboto14w500CB3B3B3,
      style: AppStyle.roboto16w500C545454,
      labelStyle: AppStyle.roboto14w500C000000,
      enabledBorderColor: AppColors.black30opacity4D000000,
      focusedBorderColor: AppColors.yellowFFD673,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormField(
      controller: _authController.confirmController.value,
      labelText: AppStrings.confirmPasswordHint.tr,
      hintText: AppStrings.confirmPasswordHint.tr,
      suffixIcon: _passwordVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      obscureText: !_passwordVisible,
      onSuffixIconTap: _togglePasswordVisibility,
      hintStyle: AppStyle.roboto14w500CB3B3B3,
      style: AppStyle.roboto16w500C545454,
      labelStyle: AppStyle.roboto14w500C000000,
      enabledBorderColor: AppColors.black30opacity4D000000,
      focusedBorderColor: AppColors.yellowFFD673,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: _onRememberMeChanged,
          activeColor: AppColors.yellowFFD673,
        ),
        Text(
          AppStrings.rememberMe.tr,
          style: AppStyle.roboto14w400C000000,
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return AppButton(
      text: AppStrings.signUp.tr,
      onPressed: () => _authController.signup(context: context),
      width: double.infinity,
      height: 48.h,
      backgroundColor: AppColors.yellowFFD673,
      borderRadius: 8,
      textStyle: AppStyle.inter16w700CFFFFFF,
    );
  }

  Widget _buildSignInOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAAccount.tr,
          style: AppStyle.roboto14w400C000000,
        ),
        GestureDetector(
          onTap: () => context.push(RoutePath.auth.addBasePath),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  AppStrings.signIn.tr,
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
        _buildSocialIcon(
          iconPath: Assets.icons.appleSignin.path,
          onTap: _signInWithApple,
        ),
        Gap(15.w),
        _buildSocialIcon(
          iconPath: Assets.icons.google.path,
          onTap: _signInWithGoogle,
        ),
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

  void _onRememberMeChanged(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _signInWithApple() {
    // Implement Apple sign in
  }

  void _signInWithGoogle() {
    // Implement Google sign in
  }
}
