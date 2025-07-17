import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:groc_shopy/core/custom_assets/assets.gen.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/routes/route_path.dart';
import '../../../global/model/user_order_list.dart';
import '../../../service/payment_service.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_navbar/navbar_controller.dart';
import '../../widgets/subscription_plans/subscription_plans.dart';
import '../auth/controller/auth_controller.dart';
import 'controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final BottomNavController controller = Get.find<BottomNavController>();
  final ProfileController profileCtrl = Get.put(ProfileController());
  final AuthController _authController = Get.find<AuthController>();
  // Add a ScrollController for pagination
  final ScrollController _allTabScrollController = ScrollController();

  void _setupScrollListener(BuildContext context) {
    _allTabScrollController.addListener(() {
      if (_allTabScrollController.position.pixels >=
              _allTabScrollController.position.maxScrollExtent - 100 &&
          profileCtrl.isTotal.value &&
          !profileCtrl.isLoadingOrders.value) {
        profileCtrl.fetchNextPage();
      }
    });
  }

  Future<void> _showPickOptionsDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 260.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Take Photo',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      profileCtrl.pickImage(ImageSource.camera);
                    },
                    child: Container(
                      width: 100.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 40.sp, color: Colors.black54),
                          SizedBox(height: 10.h),
                          Text(
                            'Camera',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      profileCtrl.pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      width: 100.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library,
                              size: 40.sp, color: Colors.black54),
                          SizedBox(height: 10.h),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.black87),
                          ),
                        ],
                      ),
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

  void _showFullImage(
      BuildContext context, File? imageFile, String? networkImageUrl) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.9),
          alignment: Alignment.center,
          child: InteractiveViewer(
            child: imageFile != null
                ? Image.file(imageFile)
                : (networkImageUrl != null && networkImageUrl.isNotEmpty
                    ? Image.network(networkImageUrl)
                    : Image.asset(Assets.images.profileImage.path)),
          ),
        ),
      ),
    );
  }

  void _showInvoiceImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.9),
          alignment: Alignment.center,
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupScrollListener(context);
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  color: AppColors.backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        AppStrings.profile.tr,
                        style: AppStyle.kohSantepheap16w700C3F3F3F,
                      ),
                      InkWell(
                        onTap: () {
                          controller.changeIndex(0);
                          _authController.logout(context: context);
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 350.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.brocoli.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 55.h,
                      child: Obx(() => GestureDetector(
                            // behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _showPickOptionsDialog(context);
                            },
                            onLongPress: () {
                              _showFullImage(
                                context,
                                profileCtrl.profileImageFile.value,
                                profileCtrl.profileImageUrl.value,
                              );
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 36.r,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 32.r,
                                    backgroundImage: profileCtrl
                                                .profileImageFile.value !=
                                            null
                                        ? FileImage(
                                            profileCtrl.profileImageFile.value!)
                                        : (profileCtrl.profileImageUrl.value
                                                .isNotEmpty
                                            ? NetworkImage(profileCtrl
                                                .profileImageUrl.value)
                                            : AssetImage(Assets
                                                .images
                                                .profileImage
                                                .path)) as ImageProvider,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 15.w,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                Gap(50.h),
                Text(
                  profileCtrl.name.value,
                  style: AppStyle.kohSantepheap16w700C3F3F3F,
                ),
                Gap(4.h),
                Text(
                  profileCtrl.role.value,
                  style: AppStyle.roboto12w400C80000000,
                ),
                Gap(2.h),
                Text(
                  AppStrings.appName.tr,
                  style: AppStyle.robotoSerif12w500C000000,
                ),
                Gap(12.h),
                // Align(
                //   alignment: Alignment.center,
                //   child: Text(
                //     AppStrings.addedReceipt.tr,
                //     style: AppStyle.kohSantepheap16w700C000000,
                //   ),
                // ),
                // Gap(21.h),
                UpgradeBanner(),
                Gap(21.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.addedReceipt.tr,
                    style: AppStyle.kohSantepheap16w700C000000,
                  ),
                ),
                Gap(21.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleTab(
                      AppStrings.recent.tr,
                      !profileCtrl.isTotal.value,
                      () => profileCtrl.setTab(false),
                    ),
                    _buildRoleTab(
                      AppStrings.all.tr,
                      profileCtrl.isTotal.value,
                      () => profileCtrl.setTab(true),
                    ),
                  ],
                ),
                Expanded(
                  child: profileCtrl.isLoadingOrders.value &&
                          profileCtrl.userOrders.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : profileCtrl.userOrders.isEmpty
                          ? Center(child: Text('No orders found'))
                          : ListView.builder(
                              controller: profileCtrl.isTotal.value
                                  ? _allTabScrollController
                                  : null,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: profileCtrl.userOrders.length +
                                  (profileCtrl.isTotal.value &&
                                          profileCtrl.isLoadingOrders.value
                                      ? 1
                                      : 0),
                              itemBuilder: (_, i) {
                                if (i < profileCtrl.userOrders.length) {
                                  return receiptItemFromOrder(
                                    profileCtrl.userOrders[i],
                                    () => _showInvoiceImage(context,
                                        profileCtrl.userOrders[i].image),
                                  );
                                } else {
                                  // Show loading indicator at the end
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                ),
              ],
            )),
      ),
    );
  }
}

Widget _buildRoleTab(String title, bool selected, VoidCallback onTap) {
  final color =
      selected ? AppColors.yellowFFD673 : AppColors.black50opacity80000000;
  final fontWeight = selected ? FontWeight.bold : FontWeight.normal;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: 175.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppStyle.roboto16w700CFFD673.copyWith(
              fontWeight: fontWeight,
              color: color,
            ),
          ),
          Gap(12.h),
          Container(
            height: selected ? 4.h : 1.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget receiptItemFromOrder(Order order, void Function() onImageTap) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.h),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: onImageTap,
          child: Image.network(order.image,
              width: 70.w, height: 70.h, fit: BoxFit.cover),
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.shopName, style: AppStyle.roboto12w400C000000),
              Gap(4.h),
              Text(
                'Items: ${order.categories.map((c) => c.name).join(', ')}',
                style: AppStyle.roboto10w400CB2000000,
              ),
            ],
          ),
        ),
        Text('\$${order.totalAmount}', style: AppStyle.roboto12w400CFFD673),
        Gap(10.w),
      ],
    ),
  );
}

class UpgradeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future<void> _showSubscriptionPlansAndPay() async {
    //   try {
    //     // Show loading using root navigator
    //     showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (context) =>
    //           const Center(child: CircularProgressIndicator()),
    //     );

    //     // Fetch plans
    //     final plans = await PaymentService.getSubscriptionPlans();

    //     // Dismiss loading
    //     Navigator.of(context, rootNavigator: true).pop();

    //     // Show plans using root navigator
    //     if (context.mounted) {
    //       await showModalBottomSheet(
    //         context: context,
    //         isScrollControlled: true,
    //         backgroundColor: Colors.transparent,
    //         builder: (_) => SubscriptionPlansBottomSheet(
    //           plans: plans,
    //           onSubscribe: (selectedPlan) async {
    //             // Navigator.of(context).pop(); // Close plans sheet
    //             await PaymentService.handlePayment(
    //               selectedPlan.planId,
    //               context,
    //               planName: selectedPlan.name,
    //             );
    //           },
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     if (context.mounted) {
    //       Navigator.of(context, rootNavigator: true).pop();
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Error: ${e.toString()}')),
    //       );
    //     }
    //   }
    // }
    Future<void> _showSubscriptionPlansAndPay() async {
      try {
        final paywallResult = await RevenueCatUI.presentPaywallIfNeeded('pro');
        log("Paywall result: $paywallResult");
        //log error if paywall fails
        log("Paywall result: ${paywallResult}. If you see an error, check your RevenueCat setup.");
      } catch (e) {
        log("Error presenting paywall: $e");
      }
    }

    return Container(
      alignment: Alignment.center,
      width: 349.w,
      height: 118.h,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCCB5E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.appName.tr,
            style: AppStyle.robotoSerif16w700CFFFFFF,
          ),
          Text(
            AppStrings.unlockExclusiveFeatures.tr,
            textAlign: TextAlign.center,
            style: AppStyle.roboto11w400CFFFFFF,
          ),
          AppButton(
            width: 170.w,
            height: 32.h,
            backgroundColor: Colors.white,
            borderRadius: 20,
            text: AppStrings.upgradeNow.tr,
            textStyle: AppStyle.inter14w500C000000,
            onPressed: _showSubscriptionPlansAndPay,
          ),
        ],
      ),
    );
  }
}
