import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // for `.tr`
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import 'package:lottie/lottie.dart';
import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';

class UpdatePasswordSuccessScreen extends StatelessWidget {
  const UpdatePasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSuccessIcon(),
              Gap(31.h),
              _buildMessageCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSuccessIcon() {
  //   return Container(
  //     width: 98.w,
  //     height: 98.h,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF1F5FF),
  //       shape: BoxShape.circle,
  //       border: Border.all(color: const Color(0xFFFDD472), width: 2.w),
  //     ),
  //     child: Center(
  //       child: Icon(
  //         Icons.check,
  //         color: const Color(0xFFFDD472),
  //         size: 40.w,
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSuccessIcon() {
    return Container(
      // width: 98.w,
      // height: 98.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFDD472), width: 2.w),
      ),
      child: Lottie.asset(
        'assets/animation/success.json',
        width: 200.w,
        height: 200.h,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 380.w, maxHeight: 230.h),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildTitle(),
          Gap(24.h),
          _buildSubtitle(),
          Gap(33.h),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      AppStrings.successful.tr,
      style: AppStyle.robotoSerif20w600C1E1E1E,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      AppStrings.congratulations.tr,
      style: AppStyle.roboto16w500C989898,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return AppButton(
      text: AppStrings.updatePassword.tr,
      onPressed: () => context.push(RoutePath.auth.addBasePath),
      width: 268.w,
      height: 44.h,
      backgroundColor: const Color(0xFFF7C95C),
      borderRadius: 15,
      textStyle: AppStyle.inter16w700CFFFFFF,
    );
  }
}
