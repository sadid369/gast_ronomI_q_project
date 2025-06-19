import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'controller/auth_controller.dart'; // adjust import path if needed
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({super.key});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  static const int _codeLength = 5;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  final AuthController _authController = Get.find();

  bool get _isCodeComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _codeLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int idx, String value) {
    if (value.length > 1) {
      _controllers[idx].text = value[0];
    }
    if (value.isNotEmpty && idx < _codeLength - 1) {
      _focusNodes[idx + 1].requestFocus();
    } else if (value.isEmpty && idx > 0) {
      _focusNodes[idx - 1].requestFocus();
    }
    setState(() {});
  }

  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();
    final email = _authController.emailController.value.text;
    _authController.verifyResetOtp(
      context: context,
      email: email,
      otp: code,
    );
    // context.push(
    //   RoutePath.resetPassConfirm.addBasePath,
    // );7
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // you can show a loading overlay if you want
        if (_authController.verifyResetOtpLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(),
                const Gap(16),
                _buildHeader(),
                const Gap(24),
                _buildCodeInputFields(),
                const Gap(24),
                _buildVerifyButton(),
                const Gap(16),
                _buildResendRow(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Image.asset(Assets.icons.arrowBackGrey.path),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.checkYourEmail.tr,
          style: AppStyle.kohSantepheap18w700C1E1E1E,
        ),
        const Gap(18),
        Wrap(
          children: [
            Text(
              AppStrings.weSent.tr,
              style: AppStyle.roboto14w600C989898,
            ),
            Text(
              AppStrings.emailText.tr,
              style: AppStyle.roboto14w600C545454,
            ),
          ],
        ),
        const Gap(10),
        Text(
          AppStrings.enterYour5Digit.tr,
          style: AppStyle.roboto14w600C989898,
        ),
      ],
    );
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_codeLength, (i) => _buildCodeField(i)),
    );
  }

  Widget _buildCodeField(int index) {
    return SizedBox(
      width: 56.w,
      height: 56.h,
      child: CustomTextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        style: AppStyle.poppins18w600C545454,
        contentPadding: const EdgeInsets.symmetric(vertical: 0).h,
        borderRadius: BorderRadius.circular(8),
        enabledBorderColor: _controllers[index].text.isEmpty
            ? AppColors.borderE1E1E1
            : AppColors.yellowFFD673,
        enabledBorderWidth: 3.w,
        focusedBorderColor: AppColors.yellowFFD673,
        focusedBorderWidth: 3.w,
        showCounter: false,
        filled: false,
        onChanged: (v) => _onCodeChanged(index, v),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return AppButton(
      text: AppStrings.verifyCode.tr,
      onPressed: _isCodeComplete ? _verifyCode : null,
      enabled: _isCodeComplete,
      width: double.infinity,
      height: 48.h,
      backgroundColor: AppColors.yellowFFD673,
      disabledBackgroundColor: AppColors.yellowFFD673.withOpacity(0.4),
      borderRadius: 10,
      textStyle: AppStyle.inter16w700CFFFFFF,
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.haveNotGotTheMail.tr,
          style: AppStyle.inter14w600C989898,
        ),
        const Gap(4),
        GestureDetector(
          onTap: () {
            // TODO: add resend logic
          },
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2).h,
                child: Text(
                  AppStrings.resendEmail.tr,
                  style: AppStyle.inter14w600CFFD673U,
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
}
