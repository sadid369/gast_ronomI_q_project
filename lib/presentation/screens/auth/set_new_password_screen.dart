// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:groc_shopy/helper/extension/base_extension.dart';
// import 'package:groc_shopy/utils/app_colors/app_colors.dart';
// import 'package:groc_shopy/utils/text_style/text_style.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../core/routes/route_path.dart';
// import '../../../utils/static_strings/static_strings.dart';
// import '../../widgets/custom_bottons/custom_button/app_button.dart';
// import '../../widgets/custom_text_form_field/custom_text_form.dart';

// class SetPasswordScreen extends StatefulWidget {
//   const SetPasswordScreen({super.key});

//   @override
//   State<SetPasswordScreen> createState() => _SetPasswordScreenState();
// }

// class _SetPasswordScreenState extends State<SetPasswordScreen> {
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   void _toggleConfirmPasswordVisibility() {
//     setState(() {
//       _obscureConfirmPassword = !_obscureConfirmPassword;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final inputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: const BorderSide(color: Color(0xFFE9E1D5)),
//     );

//     return Scaffold(
//       // light cream background
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back Button
//               GestureDetector(
//                 onTap: () {
//                   context.pop();
//                 },
//                 child: Image.asset(
//                   Assets.icons.arrowBackGrey.path,
//                 ),
//               ),
//               Gap(53.h),
//               // Title
//               Text(
//                 AppStrings.setANewPassword,
//                 style: AppStyle.kohSantepheap18w700C1E1E1E,
//               ),
//               Gap(18.h),
//               Text(
//                 AppStrings.createANewPassword,
//                 style: AppStyle.roboto14w500C989898,
//               ),
//               Gap(44.h),
//               // Password Field
//               Text(
//                 AppStrings.password,
//                 style: AppStyle.roboto16w600C2A2A2A,
//               ),
//               Gap(8.h),
//               CustomTextFormField(
//                 controller: _passwordController,
//                 hintText: AppStrings.enterYourNewPassword,
//                 obscureText: _obscurePassword,
//                 suffixIcon: _obscurePassword
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 onSuffixIconTap: _togglePasswordVisibility,
//                 style: AppStyle.roboto16w500C545454,
//                 hintStyle: AppStyle.roboto14w500CB3B3B3,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 enabledBorderColor: AppColors.borderE1E1E1,
//                 focusedBorderColor: AppColors.borderE1E1E1,
//                 enabledBorderWidth: 1.5.w,
//                 focusedBorderWidth: 1.8.w,
//                 borderRadius: BorderRadius.circular(12.dg),
//               ),

//               Gap(16.h),

//               Text(
//                 AppStrings.confirmPasswordHint,
//                 style: AppStyle.roboto16w600C2A2A2A,
//               ),

//               Gap(8.h),

//               CustomTextFormField(
//                 controller: _confirmPasswordController,
//                 hintText: AppStrings.reEnterPassword,
//                 obscureText: _obscureConfirmPassword,
//                 suffixIcon: _obscureConfirmPassword
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 onSuffixIconTap: _toggleConfirmPasswordVisibility,
//                 style: AppStyle.roboto16w500C545454,
//                 hintStyle: AppStyle.roboto14w500CB3B3B3,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 enabledBorderColor: AppColors.borderE1E1E1,
//                 focusedBorderColor: AppColors.borderE1E1E1,
//                 enabledBorderWidth: 1.5.w,
//                 focusedBorderWidth: 1.8.w,
//                 borderRadius: BorderRadius.circular(12.dg),
//               ),

//               Gap(30.h),

//               AppButton(
//                 text: AppStrings.updatePassword,
//                 onPressed: () {
//                   context.push(RoutePath.resetPasswordSuccess.addBasePath);
//                 },
//                 width: double.infinity,
//                 height: 48.h,
//                 backgroundColor: const Color(0xFFF7C95C),
//                 borderRadius: 8,
//                 textStyle: AppStyle.inter16w700CFFFFFF,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // <-- for .tr translation
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
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE9E1D5)),
    );

    return Scaffold(
      // light cream background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Image.asset(
                    Assets.icons.arrowBackGrey.path,
                  ),
                ),
                Gap(53.h),
                // Title
                Text(
                  AppStrings.setANewPassword.tr,
                  style: AppStyle.kohSantepheap18w700C1E1E1E,
                ),
                Gap(18.h),
                Text(
                  AppStrings.createANewPassword.tr,
                  style: AppStyle.roboto14w500C989898,
                ),
                Gap(44.h),
                // Password Field
                Text(
                  AppStrings.password.tr,
                  style: AppStyle.roboto16w600C2A2A2A,
                ),
                Gap(8.h),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: AppStrings.enterYourNewPassword.tr,
                  obscureText: _obscurePassword,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixIconTap: _togglePasswordVisibility,
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

                Gap(16.h),

                Text(
                  AppStrings.confirmPasswordHint.tr,
                  style: AppStyle.roboto16w600C2A2A2A,
                ),

                Gap(8.h),

                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: AppStrings.reEnterPassword.tr,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixIconTap: _toggleConfirmPasswordVisibility,
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

                Gap(30.h),

                AppButton(
                  text: AppStrings.updatePassword.tr,
                  onPressed: () {
                    context.push(RoutePath.resetPasswordSuccess.addBasePath);
                  },
                  width: double.infinity,
                  height: 48.h,
                  backgroundColor: const Color(0xFFF7C95C),
                  borderRadius: 8,
                  textStyle: AppStyle.inter16w700CFFFFFF,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
