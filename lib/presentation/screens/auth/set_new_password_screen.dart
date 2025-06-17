import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // for `.tr`
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _togglePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirm() => setState(() => _obscureConfirm = !_obscureConfirm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(),
                Gap(53.h),
                _buildTitle(),
                Gap(18.h),
                _buildSubtitle(),
                Gap(44.h),
                _buildPasswordField(),
                Gap(16.h),
                _buildConfirmField(),
                Gap(30.h),
                _buildUpdateButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() => GestureDetector(
        onTap: () => context.pop(),
        child: Image.asset(Assets.icons.arrowBackGrey.path),
      );

  Widget _buildTitle() => Text(
        AppStrings.setANewPassword.tr,
        style: AppStyle.kohSantepheap18w700C1E1E1E,
      );

  Widget _buildSubtitle() => Text(
        AppStrings.createANewPassword.tr,
        style: AppStyle.roboto14w500C989898,
      );

  Widget _buildPasswordField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.password.tr, style: AppStyle.roboto16w600C2A2A2A),
          Gap(8.h),
          CustomTextFormField(
            controller: _passwordController,
            hintText: AppStrings.enterYourNewPassword.tr,
            obscureText: _obscurePassword,
            suffixIcon: _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixIconTap: _togglePassword,
            style: AppStyle.roboto16w500C545454,
            hintStyle: AppStyle.roboto14w500CB3B3B3,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            enabledBorderColor: AppColors.black30opacity4D000000,
            focusedBorderColor: AppColors.yellowFFD673,
            enabledBorderWidth: 1.5.w,
            focusedBorderWidth: 1.8.w,
            borderRadius: BorderRadius.circular(12.dg),
          ),
        ],
      );

  Widget _buildConfirmField() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.confirmPasswordHint.tr,
              style: AppStyle.roboto16w600C2A2A2A),
          Gap(8.h),
          CustomTextFormField(
            controller: _confirmController,
            hintText: AppStrings.reEnterPassword.tr,
            obscureText: _obscureConfirm,
            suffixIcon: _obscureConfirm
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixIconTap: _toggleConfirm,
            style: AppStyle.roboto16w500C545454,
            hintStyle: AppStyle.roboto14w500CB3B3B3,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            enabledBorderColor: AppColors.black30opacity4D000000,
            focusedBorderColor: AppColors.yellowFFD673,
            enabledBorderWidth: 1.5.w,
            focusedBorderWidth: 1.8.w,
            borderRadius: BorderRadius.circular(12.dg),
          ),
        ],
      );

  Widget _buildUpdateButton(BuildContext ctx) => AppButton(
        text: AppStrings.updatePassword.tr,
        onPressed: () => ctx.push(RoutePath.resetPasswordSuccess.addBasePath),
        width: double.infinity,
        height: 48.h,
        backgroundColor: const Color(0xFFF7C95C),
        borderRadius: 8,
        textStyle: AppStyle.inter16w700CFFFFFF,
      );
}
