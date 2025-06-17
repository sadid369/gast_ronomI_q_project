import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // for `.tr`
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/text_style/text_style.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    final isNotEmpty = value.isNotEmpty;
    if (isNotEmpty != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  void _onSubmit() {
    context.push(RoutePath.verification.addBasePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              const SizedBox(height: 30),
              _buildHeader(),
              const Gap(20),
              _buildEmailInput(),
              Gap(30.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext ctx) {
    return GestureDetector(
      onTap: () => ctx.pop(),
      child: Image.asset(Assets.icons.arrowBackGrey.path),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.forgotPassword.tr,
          style: AppStyle.kohSantepheap18w700C1E1E1E,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.pleaseEnterYourEmailToReset.tr,
          style: AppStyle.roboto14w600C989898,
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.youEmail.tr,
          style: AppStyle.roboto16w600C2A2A2A,
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: _emailController,
          onChanged: _onEmailChanged,
          hintText: AppStrings.enterYourEmailHint.tr,
          keyboardType: TextInputType.emailAddress,
          style: AppStyle.roboto16w500C545454,
          hintStyle: AppStyle.roboto14w500CB3B3B3,
          fillColor: Colors.transparent,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          enabledBorderColor: AppColors.borderE1E1E1,
          focusedBorderColor: AppColors.yellowFFD673,
          enabledBorderWidth: 1.5.w,
          focusedBorderWidth: 1.8.w,
          borderRadius: BorderRadius.circular(12.dg),
          filled: true,
          obscureText: false,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: AppStrings.passwordReset.tr,
      onPressed: _isButtonEnabled ? _onSubmit : null,
      enabled: _isButtonEnabled,
      width: double.infinity,
      height: 48.h,
      backgroundColor: AppColors.yellowFFD673,
      disabledBackgroundColor: AppColors.yellowFFD673.withOpacity(0.4),
      borderRadius: 10,
      textStyle: AppStyle.inter16w700CFFFFFF,
    );
  }
}
