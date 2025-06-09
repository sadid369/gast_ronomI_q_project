// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:groc_shopy/helper/extension/base_extension.dart';
// import 'package:groc_shopy/utils/app_colors/app_colors.dart';
// import 'package:groc_shopy/utils/static_strings/static_strings.dart';
// import 'package:groc_shopy/utils/text_style/text_style.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../core/routes/route_path.dart';
// import '../../widgets/custom_bottons/custom_button/app_button.dart';
// import '../../widgets/custom_text_form_field/custom_text_form.dart';

// class AdminSignUpScreen extends StatefulWidget {
//   const AdminSignUpScreen({super.key});

//   @override
//   AdminSignUpScreenState createState() => AdminSignUpScreenState();
// }

// class AdminSignUpScreenState extends State<AdminSignUpScreen> {
//   bool isAdmin = true;
//   bool rememberMe = false;
//   bool passwordVisible = false;

//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     fullNameController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Replace with your own asset path
//                   Image.asset(
//                     Assets.icons.logo.path,
//                     height: 70.h,
//                     width: 70.w,
//                   ),
//                   Gap(16.h),
//                   Text(
//                     AppStrings.adminSignUp,
//                     style: AppStyle.kohSantepheap18w700CFFD673,
//                   ),
//                   Gap(24.h),
//                   // Tab bar for Employee/Admin
//                   Container(
//                     height: 1.h,
//                     decoration: BoxDecoration(
//                       color: AppColors.black50opacity80000000,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   ),
//                   Gap(42.h),

//                   Gap(36.h),
//                   CustomTextFormField(
//                     controller: fullNameController,
//                     labelText: AppStrings.fullName,
//                     hintText: AppStrings.enterYourFullName,
//                     suffixIconSvgAsset: Assets.icons.fullName
//                         .path, // make sure it's a string path to SVG asset
//                     obscureText: false,
//                     style: AppStyle.roboto14w400C80000000,
//                     labelStyle: AppStyle.roboto14w500C000000,
//                     enabledBorderColor: AppColors.black30opacity4D000000,
//                     focusedBorderColor: AppColors.darkGrayText3F3F3F,
//                     fillColor: Colors.white,
//                     contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
//                   ),

//                   Gap(35.h),

//                   CustomTextFormField(
//                     controller: emailController,
//                     labelText: AppStrings.email,
//                     hintText: AppStrings.enterYourEmailHint,
//                     suffixIcon: Icons.email_outlined,
//                     obscureText: false,
//                     style: AppStyle.roboto14w400C80000000,
//                     labelStyle: AppStyle.roboto14w500C000000,
//                     enabledBorderColor: AppColors.black30opacity4D000000,
//                     focusedBorderColor: AppColors.darkGrayText3F3F3F,
//                     fillColor: Colors.white,
//                     contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
//                   ),
//                   Gap(35.h),

//                   CustomTextFormField(
//                     controller: passwordController,
//                     labelText: AppStrings.password,
//                     hintText: AppStrings.passwordHint,
//                     suffixIcon: passwordVisible
//                         ? Icons.visibility_outlined
//                         : Icons.visibility_off_outlined,
//                     obscureText: !passwordVisible,
//                     onSuffixIconTap: () {
//                       setState(() {
//                         passwordVisible = !passwordVisible;
//                       });
//                     },
//                     style: AppStyle.roboto14w400C80000000,
//                     labelStyle: AppStyle.roboto14w500C000000,
//                     enabledBorderColor: AppColors.black30opacity4D000000,
//                     focusedBorderColor: AppColors.darkGrayText3F3F3F,
//                     fillColor: Colors.white,
//                     contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
//                   ),

//                   // Remember Me checkbox
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: rememberMe,
//                         onChanged: (val) {
//                           setState(() {
//                             rememberMe = val ?? false;
//                           });
//                         },
//                         activeColor: AppColors.yellowFFD673,
//                       ),
//                       Text(
//                         AppStrings.rememberMe,
//                         style: AppStyle.roboto14w400C000000,
//                       ),
//                     ],
//                   ),

//                   Gap(33.h),

//                   AppButton(
//                     text: AppStrings.signUp,
//                     onPressed: () {
//                       // Handle sign in logic here
//                     },
//                     width: double.infinity,
//                     height: 48.h,
//                     backgroundColor: AppColors.yellowFFD673,
//                     borderRadius: 8,
//                     textStyle: AppStyle.inter16w700CFFFFFF,
//                   ),

//                   Gap(15.h),

//                   // Sign up and forget password texts
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         AppStrings.dontHaveAAccount,
//                         style: AppStyle.roboto14w400C000000,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           // Navigate to Sign up screen
//                           context.push(RoutePath.auth.addBasePath);
//                         },
//                         child: Stack(
//                           alignment: Alignment.centerLeft,
//                           children: [
//                             // The text itself
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   bottom: 2
//                                       .h), // Adds space between text and underline
//                               child: Text(
//                                 AppStrings.signIn, // Your text

//                                 style: AppStyle.roboto14w500CFFD673,
//                               ),
//                             ),
//                             // The underline with custom gap
//                             Positioned(
//                               bottom:
//                                   0, // Position the underline at the bottom of the text
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 height: 2.h, // Thickness of the underline
//                                 color: AppColors
//                                     .yellowFFD673, // Color of the underline
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   Gap(12.w),

//                   Text(
//                     AppStrings.or,
//                     style: AppStyle.roboto14w500C80000000,
//                   ),

//                   Gap(12.h),

//                   // Social icons row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildSocialIcon(
//                         iconPath: Assets.icons.appleSignin.path,
//                         onTap: () {
//                           // Facebook login
//                         },
//                       ),
//                       Gap(15.w),
//                       _buildSocialIcon(
//                         iconPath: Assets.icons.google.path,
//                         onTap: () {
//                           // Google login
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialIcon({
//     required String iconPath,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         // radius: 35,
//         backgroundColor: Colors.transparent,
//         child: Image.asset(
//           iconPath,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // <-- add this import
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_text_form_field/custom_text_form.dart';
import 'package:http/http.dart' as http;

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  AdminSignUpScreenState createState() => AdminSignUpScreenState();
}

class AdminSignUpScreenState extends State<AdminSignUpScreen> {
  bool isAdmin = true;
  bool rememberMe = false;
  bool passwordVisible = false;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.icons.logo.path,
                    height: 70.h,
                    width: 70.w,
                  ),
                  Gap(16.h),
                  Text(
                    AppStrings.adminSignUp.tr, // <-- add .tr here
                    style: AppStyle.kohSantepheap18w700CFFD673,
                  ),
                  Gap(24.h),
                  Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppColors.black50opacity80000000,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  Gap(42.h),
                  Gap(36.h),
                  CustomTextFormField(
                    controller: fullNameController,
                    labelText: AppStrings.fullName.tr, // <-- .tr
                    hintText: AppStrings.enterYourFullName.tr, // <-- .tr
                    // suffixIconSvgAsset: Assets.icons.fullName.path,
                    suffixIcon: Icons.person_outline,
                    obscureText: false,
                    hintStyle: AppStyle.roboto14w500CB3B3B3,
                    style: AppStyle.roboto16w500C545454,
                    labelStyle: AppStyle.roboto14w500C000000,
                    enabledBorderColor: AppColors.black30opacity4D000000,
                    focusedBorderColor: AppColors.yellowFFD673,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
                  ),
                  Gap(35.h),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: AppStrings.email.tr, // <-- .tr
                    hintText: AppStrings.enterYourEmailHint.tr, // <-- .tr
                    suffixIcon: Icons.email_outlined,
                    obscureText: false,
                    hintStyle: AppStyle.roboto14w500CB3B3B3,
                    style: AppStyle.roboto16w500C545454,
                    labelStyle: AppStyle.roboto14w500C000000,
                    enabledBorderColor: AppColors.black30opacity4D000000,
                    focusedBorderColor: AppColors.yellowFFD673,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
                  ),
                  Gap(35.h),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: AppStrings.password.tr, // <-- .tr
                    hintText: AppStrings.password.tr, // <-- .tr
                    suffixIcon: passwordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    obscureText: !passwordVisible,
                    onSuffixIconTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    hintStyle: AppStyle.roboto14w500CB3B3B3,
                    style: AppStyle.roboto16w500C545454,
                    labelStyle: AppStyle.roboto14w500C000000,
                    enabledBorderColor: AppColors.black30opacity4D000000,
                    focusedBorderColor: AppColors.yellowFFD673,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
                  ),
                  Gap(35.h),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    labelText: AppStrings.confirmPasswordHint.tr, // <-- .tr
                    hintText: AppStrings.confirmPasswordHint.tr, // <-- .tr
                    suffixIcon: passwordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    obscureText: !passwordVisible,
                    onSuffixIconTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    hintStyle: AppStyle.roboto14w500CB3B3B3,
                    style: AppStyle.roboto16w500C545454,
                    labelStyle: AppStyle.roboto14w500C000000,
                    enabledBorderColor: AppColors.black30opacity4D000000,
                    focusedBorderColor: AppColors.yellowFFD673,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 14.h),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) {
                          setState(() {
                            rememberMe = val ?? false;
                          });
                        },
                        activeColor: AppColors.yellowFFD673,
                      ),
                      Text(
                        AppStrings.rememberMe.tr, // <-- .tr
                        style: AppStyle.roboto14w400C000000,
                      ),
                    ],
                  ),
                  Gap(33.h),
                  AppButton(
                    text: AppStrings.signUp.tr, // <-- .tr
                    onPressed: () async {
                      // Handle sign in logic here
                      final response = await http.get(Uri.parse(
                          "http://10.0.70.145:8001/report/orders/recent/"));
                      debugPrint(response.body);
                    },
                    width: double.infinity,
                    height: 48.h,
                    backgroundColor: AppColors.yellowFFD673,
                    borderRadius: 8,
                    textStyle: AppStyle.inter16w700CFFFFFF,
                  ),
                  Gap(15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.dontHaveAAccount.tr, // <-- .tr
                        style: AppStyle.roboto14w400C000000,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(RoutePath.auth.addBasePath);
                        },
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Text(
                                AppStrings.signIn.tr, // <-- .tr
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
                  ),
                  Gap(12.w),
                  Text(
                    AppStrings.or.tr, // <-- .tr
                    style: AppStyle.roboto14w500C80000000,
                  ),
                  Gap(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                        iconPath: Assets.icons.appleSignin.path,
                        onTap: () {},
                      ),
                      Gap(15.w),
                      _buildSocialIcon(
                        iconPath: Assets.icons.google.path,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
}
