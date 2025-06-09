import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // for .tr
import 'package:groc_shopy/core/routes/routes.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:groc_shopy/core/custom_assets/assets.gen.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';

import '../../../core/routes/route_path.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';
import '../../widgets/custom_navbar/navbar_controller.dart';
import '../../widgets/payment_modal/payment_modal.dart';
import '../../widgets/paypal/paypal.dart';
import '../../widgets/subscription_plans/subscription_plans.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final BottomNavController controller = Get.find<BottomNavController>();
  bool isTotal = true;
  late TabController _tabController;

  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> recently = [
    {
      'store': 'Shawopno',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    },
    {
      'store': 'Minabazar',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    },
    {
      'store': 'Agora',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    }
  ];

  final List<Map<String, dynamic>> total = [
    {
      'store': 'Shawopno',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    },
    {
      'store': 'Shawopno',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    },
    {
      'store': 'Minabazar',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    },
    {
      'store': 'Agora',
      'items': 'Apple, Chicken, Bread',
      'price': '\$140',
      'image': Assets.images.invoice.path,
    }
  ].reversed.toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// Inside your widget's build or a method:

  Future<void> _showPickOptionsDialog() async {
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
                      print('Camera option tapped');
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
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
                      print('Gallery option tapped');
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  void _showFullImage() {
    if (_profileImageFile == null) return; // no image to show

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(), // close on tap outside
        child: Container(
          color: Colors.black.withOpacity(0.9),
          alignment: Alignment.center,
          child: InteractiveViewer(
            child: Image.file(_profileImageFile!),
          ),
        ),
      ),
    );
  }

  Widget receiptItem(Map<String, dynamic> receipt) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 70.h,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Image.asset(
              receipt['image'],
              fit: BoxFit.contain,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt['store'],
                  style: AppStyle.roboto12w400C000000,
                ),
                Gap(4.h),
                Text(
                  'Items: ${receipt['items']}',
                  style: AppStyle.roboto10w400CB2000000,
                ),
              ],
            ),
          ),
          Text(
            receipt['price'],
            style: AppStyle.roboto12w400CFFD673,
          ),
          Gap(10.w),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: AppColors.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     context.pop();
                  //   },
                  //   child: Image.asset(
                  //     Assets.icons.arrowBackGrey.path,
                  //   ),
                  // ),
                  SizedBox(),
                  Text(
                    AppStrings.profile.tr,
                    style: AppStyle.kohSantepheap16w700C3F3F3F,
                  ),

                  InkWell(
                    onTap: () {
                      controller.changeIndex(0); // Reset to home

                      context.pushReplacement(RoutePath.auth.addBasePath);
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
                  child: GestureDetector(
                    behavior: HitTestBehavior
                        .translucent, // so taps register anywhere inside CircleAvatar bounds
                    onTap: () {
                      print('Profile picture tapped');
                      _showPickOptionsDialog();
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 36.r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 32.r,
                            backgroundImage: _profileImageFile != null
                                ? FileImage(_profileImageFile!)
                                : AssetImage(Assets.images.profileImage.path)
                                    as ImageProvider,
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
                                  color: Colors.grey.shade300, width: 1),
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
                  ),
                ),
              ],
            ),
            Gap(40.h),
            Text(
              'Alex Thomson',
              style: AppStyle.kohSantepheap16w700C3F3F3F,
            ),
            Gap(4.h),
            Text(
              'Manager',
              style: AppStyle.roboto12w400C80000000,
            ),
            Gap(2.h),
            Text(
              AppStrings.appName.tr,
              style: AppStyle.robotoSerif12w500C000000,
            ),
            Gap(12.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.addedReceipt.tr,
                style: AppStyle.kohSantepheap16w700C000000,
              ),
            ),
            Gap(21.h),
            UpgradeBanner(),
            Gap(21.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleTab(AppStrings.recently.tr, !isTotal, () {
                  setState(() {
                    isTotal = false;
                    _tabController.animateTo(0);
                  });
                }),
                _buildRoleTab(AppStrings.total.tr, isTotal, () {
                  setState(() {
                    isTotal = true;
                    _tabController.animateTo(1);
                  });
                }),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ListView.builder(
                      itemCount: isTotal ? total.length : recently.length,
                      itemBuilder: (context, index) {
                        return receiptItem(
                            isTotal ? total[index] : recently[index]);
                      },
                    ),
                  ),
                  const Center(
                    child: Text('Total tab content'),
                  ),
                ],
              ),
            ),
          ],
        ),
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

class UpgradeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showSubscriptionPlansAndPay() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SubscriptionPlansBottomSheet(
          plans: [
            SubscriptionPlan(
              title: AppStrings.monthlyPremiumPlan,
              price: '\$9.99',
              features: [AppStrings.moreScan, AppStrings.unlockMonthlyReport],
            ),
            SubscriptionPlan(
              title: AppStrings.yearlyPremiumPlan,
              price: '\$60.99',
              features: [
                AppStrings.unlimitedScan,
                AppStrings.unlockYearlyReport,
              ],
            ),
          ],
          onSubscribe: (selectedPlan) {
            // Navigator.of(context).pop(); // close bottom sheet first

            // Then open PayPal page:
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => PaypalPage(plan: selectedPlan),
            //   ),
            // );
            // context.goNamed(
            //   RoutePath.paypal,
            //   extra: selectedPlan,
            // );
          },
        ),
      );
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
