// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:groc_shopy/helper/extension/base_extension.dart';
// import 'package:groc_shopy/utils/text_style/text_style.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../core/routes/route_path.dart';
// import '../../../utils/app_colors/app_colors.dart';
// import '../../../utils/static_strings/static_strings.dart';
// import '../../widgets/custom_bottons/custom_button/app_button.dart';
// import '../../widgets/custom_text_form_field/custom_text_form.dart';

// class CodeVerificationScreen extends StatefulWidget {
//   const CodeVerificationScreen({super.key});

//   @override
//   State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
// }

// class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
//   final int codeLength = 5;
//   final List<TextEditingController> controllers = [];
//   final List<FocusNode> focusNodes = [];

//   bool get isCodeComplete =>
//       controllers.every((controller) => controller.text.isNotEmpty);

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < codeLength; i++) {
//       controllers.add(TextEditingController());
//       focusNodes.add(FocusNode());
//     }
//   }

//   @override
//   void dispose() {
//     for (final controller in controllers) {
//       controller.dispose();
//     }
//     for (final node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onCodeChanged(int index, String value) {
//     if (value.length > 1) {
//       // If user pasted more than 1 character, keep only the first
//       controllers[index].text = value[0];
//     }
//     if (value.isNotEmpty && index < codeLength - 1) {
//       FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//     } else if (value.isEmpty && index > 0) {
//       FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//     }
//     setState(() {});
//   }

//   void _verifyCode() {
//     final code = controllers.map((c) => c.text).join();
//     context.push(RoutePath.resetPassConfirm.addBasePath);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back button
//               GestureDetector(
//                 onTap: () {
//                   context.pop();
//                 },
//                 child: Image.asset(
//                   Assets.icons.arrowBackGrey.path,
//                 ),
//               ),
//               Gap(16.h),
//               Text(
//                 AppStrings.checkYourEmail,
//                 style: AppStyle.kohSantepheap18w700C1E1E1E,
//               ),
//               Gap(18.h),

//               // make the avobe code using row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Wrap(
//                           children: [
//                             Text(
//                               AppStrings.weSent,
//                               style: AppStyle.roboto14w600C989898,
//                             ),
//                             Text(
//                               AppStrings.emailText,
//                               style: AppStyle.roboto14w600C545454,
//                             ),
//                           ],
//                         ),
//                         Gap(10.h),
//                         Text(
//                           AppStrings.enterYour5Digit,
//                           style: AppStyle.roboto14w600C989898,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               Gap(24.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(codeLength, (index) {
//                   return Container(
//                     width: 56.w,
//                     height: 56.h,
//                     child: CustomTextFormField(
//                       controller: controllers[index],
//                       focusNode: focusNodes[index],
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textAlignVertical: TextAlignVertical.center,
//                       maxLength: 1,
//                       style: AppStyle.poppins18w600C545454,
//                       contentPadding: EdgeInsets.symmetric(vertical: 45.h),
//                       borderRadius: BorderRadius.circular(8),
//                       enabledBorderColor: controllers[index].text.isEmpty
//                           ? AppColors.borderE1E1E1
//                           : AppColors.yellowFFD673,
//                       enabledBorderWidth: 3.w,
//                       focusedBorderColor: AppColors.yellowFFD673,
//                       focusedBorderWidth: 3.w,
//                       showCounter: false,
//                       filled: false, // no fill color here, keep transparent
//                       onChanged: (value) => _onCodeChanged(index, value),
//                     ),
//                   );
//                 }),
//               ),

//               Gap(24.h),

//               AppButton(
//                 text: AppStrings.verifyCode,
//                 onPressed: isCodeComplete ? _verifyCode : null,
//                 width: double.infinity,
//                 height: 48,
//                 backgroundColor: AppColors.yellowFFD673,
//                 disabledBackgroundColor:
//                     AppColors.yellowFFD673.withOpacity(0.4),
//                 borderRadius: 10,
//                 textStyle: AppStyle.inter16w700CFFFFFF,
//                 enabled: isCodeComplete,
//               ),

//               Gap(16.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     AppStrings.haveNotGotTheMail,
//                     style: AppStyle.inter14w600C989898,
//                   ),
//                   GestureDetector(
//                     onTap: () {},
//                     child: Stack(
//                       alignment: Alignment.centerLeft,
//                       children: [
//                         // The text itself
//                         Padding(
//                           padding: EdgeInsets.only(
//                               bottom:
//                                   2.h), // Adds space between text and underline
//                           child: Text(
//                             AppStrings.resendEmail, // Your text
//                             style: AppStyle.inter14w600CFFD673U,
//                           ),
//                         ),
//                         // The underline with custom gap
//                         Positioned(
//                           bottom:
//                               0, // Position the underline at the bottom of the text
//                           left: 0,
//                           right: 0,
//                           child: Container(
//                             height: 2.h, // Thickness of the underline
//                             color: AppColors
//                                 .yellowFFD673, // Color of the underline
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
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
import 'package:get/get.dart'; // for .tr translations
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
  final int codeLength = 5;
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  bool get isCodeComplete =>
      controllers.every((controller) => controller.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < codeLength; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.length > 1) {
      // If user pasted more than 1 character, keep only the first
      controllers[index].text = value[0];
    }
    if (value.isNotEmpty && index < codeLength - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    setState(() {});
  }

  void _verifyCode() {
    final code = controllers.map((c) => c.text).join();
    // TODO: Add your verification logic here
    context.push(RoutePath.resetPassConfirm.addBasePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Image.asset(
                  Assets.icons.arrowBackGrey.path,
                ),
              ),
              Gap(16.h),
              Text(
                AppStrings.checkYourEmail.tr,
                style: AppStyle.kohSantepheap18w700C1E1E1E,
              ),
              Gap(18.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Gap(10.h),
                        Text(
                          AppStrings.enterYour5Digit.tr,
                          style: AppStyle.roboto14w600C989898,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(codeLength, (index) {
                  return Container(
                    alignment: Alignment.center,
                    width: 56.w,
                    height: 56.h,
                    child: CustomTextFormField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 1,
                      style: AppStyle.poppins18w600C545454,
                      // Remove large vertical padding to center text correctly:
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      borderRadius: BorderRadius.circular(8),
                      enabledBorderColor: controllers[index].text.isEmpty
                          ? AppColors.borderE1E1E1
                          : AppColors.yellowFFD673,
                      enabledBorderWidth: 3.w,
                      focusedBorderColor: AppColors.yellowFFD673,
                      focusedBorderWidth: 3.w,
                      showCounter: false,
                      filled: false,
                      onChanged: (value) => _onCodeChanged(index, value),
                    ),
                  );
                }),
              ),

              Gap(24.h),

              AppButton(
                text: AppStrings.verifyCode.tr,
                onPressed: isCodeComplete ? _verifyCode : null,
                width: double.infinity,
                height: 48,
                backgroundColor: AppColors.yellowFFD673,
                disabledBackgroundColor:
                    AppColors.yellowFFD673.withOpacity(0.4),
                borderRadius: 10,
                textStyle: AppStyle.inter16w700CFFFFFF,
                enabled: isCodeComplete,
              ),

              Gap(16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.haveNotGotTheMail.tr,
                    style: AppStyle.inter14w600C989898,
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Add resend email logic here
                    },
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
