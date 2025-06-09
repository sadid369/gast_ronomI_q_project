// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:groc_shopy/helper/extension/base_extension.dart';
// import 'package:groc_shopy/utils/app_colors/app_colors.dart';
// import 'package:groc_shopy/utils/static_strings/static_strings.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../core/routes/route_path.dart';
// import '../../../utils/text_style/text_style.dart';
// import '../../widgets/custom_bottons/custom_button/app_button.dart';
// import '../../widgets/custom_text_form_field/custom_text_form.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();
//   bool isButtonEnabled = false;

//   @override
//   void initState() {
//     super.initState();

//     emailController.addListener(() {
//       final isNotEmpty = emailController.text.isNotEmpty;
//       if (isNotEmpty != isButtonEnabled) {
//         setState(() {
//           isButtonEnabled = isNotEmpty;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   context.pop();
//                 },
//                 child: Image.asset(
//                   Assets.icons.arrowBackGrey.path,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 AppStrings.forgotPassword,
//                 style: AppStyle.kohSantepheap18w700C1E1E1E,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 AppStrings.pleaseEnterYourEmailToReset,
//                 style: AppStyle.roboto14w600C989898,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 AppStrings.youEmail,
//                 style: AppStyle.roboto16w600C2A2A2A,
//               ),
//               const SizedBox(height: 8),
//               CustomTextFormField(
//                 controller: emailController,
//                 hintText: AppStrings.enterYourEmailHint,
//                 keyboardType: TextInputType.emailAddress,
//                 style: AppStyle.roboto16w500C545454,
//                 hintStyle: AppStyle.roboto14w500CB3B3B3,
//                 // fillColor: AppColors.lightGreyTextB3B3B3,
//                 fillColor: Colors.transparent,
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//                 enabledBorderColor: AppColors.borderE1E1E1,
//                 focusedBorderColor: AppColors.borderE1E1E1,
//                 enabledBorderWidth: 1.5.w,
//                 focusedBorderWidth: 1.8.w,
//                 borderRadius: BorderRadius.circular(12.dg),
//                 filled: true,
//                 obscureText: false,
//               ),
//               Gap(30.h),
//               AppButton(
//                 text: AppStrings.passwordReset,
//                 onPressed: isButtonEnabled
//                     ? () {
//                         context.push(RoutePath.verification.addBasePath);
//                       }
//                     : null,
//                 width: double.infinity,
//                 height: 48.h,
//                 backgroundColor: AppColors.yellowFFD673,
//                 disabledBackgroundColor:
//                     AppColors.yellowFFD673.withOpacity(0.4),
//                 borderRadius: 10,
//                 textStyle: AppStyle.inter16w700CFFFFFF,
//                 enabled: isButtonEnabled,
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
import 'package:get/get.dart'; // <-- add this
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
  final TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      final isNotEmpty = emailController.text.isNotEmpty;
      if (isNotEmpty != isButtonEnabled) {
        setState(() {
          isButtonEnabled = isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Image.asset(
                  Assets.icons.arrowBackGrey.path,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                AppStrings.forgotPassword.tr,
                style: AppStyle.kohSantepheap18w700C1E1E1E,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.pleaseEnterYourEmailToReset.tr,
                style: AppStyle.roboto14w600C989898,
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.youEmail.tr,
                style: AppStyle.roboto16w600C2A2A2A,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: emailController,
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
              Gap(30.h),
              AppButton(
                text: AppStrings.passwordReset.tr,
                onPressed: isButtonEnabled
                    ? () {
                        context.push(RoutePath.verification.addBasePath);
                      }
                    : null,
                width: double.infinity,
                height: 48.h,
                backgroundColor: AppColors.yellowFFD673,
                disabledBackgroundColor:
                    AppColors.yellowFFD673.withOpacity(0.4),
                borderRadius: 10,
                textStyle: AppStyle.inter16w700CFFFFFF,
                enabled: isButtonEnabled,
              )
            ],
          ),
        ),
      ),
    );
  }
}
