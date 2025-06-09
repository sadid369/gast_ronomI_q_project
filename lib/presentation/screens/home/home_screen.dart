import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/core/routes/route_path.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../global/language/controller/language_controller.dart';
import '../../widgets/subscription_plans/subscription_plans.dart';
import '../../widgets/subscription_modal/subscription_modal.dart';
import 'package:auto_size_text/auto_size_text.dart'; // <-- Import AutoSizeText

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LanguageController _languageController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const SubscriptionModal(),
      );
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     backgroundColor: Colors.transparent,
    //     builder: (_) => SubscriptionPlansBottomSheet(
    //       plans: [
    //         SubscriptionPlan(
    //           title: AppStrings.monthlyPremiumPlan,
    //           price: '€9.99',
    //           features: [AppStrings.moreScan, AppStrings.unlockMonthlyReport],
    //         ),
    //         SubscriptionPlan(
    //           title: AppStrings.yearlyPremiumPlan,
    //           price: '€60.99',
    //           features: [
    //             AppStrings.unlimitedScan,
    //             AppStrings.unlockYearlyReport
    //           ],
    //         ),
    //       ],
    //       onSubscribe: () {
    //         // Your subscribe logic here
    //         Navigator.of(context).pop(); // close bottom sheet
    //       },
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3E8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: const NetworkImage(
                              'https://randomuser.me/api/portraits/men/32.jpg'),
                        ),
                        Gap(12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.w,
                          children: [
                            Text(
                              'Alex Thomson',
                              style: AppStyle.kohSantepheap16w700C3F3F3F,
                            ),
                            Text(
                              AppStrings.yourGroceryExpensesAtAGlance.tr,
                              style: AppStyle.roboto12w400C80000000,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 24.h,
                          width: 24.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Image.asset(
                            Assets.icons.shop.path,
                            height: 24.h,
                            width: 24.w,
                          ),
                        ),
                        Gap(6.w),
                        GestureDetector(
                          onTap: () async {
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;

                            final selected = await showMenu<String>(
                              context: context,
                              position: RelativeRect.fromRect(
                                Rect.fromPoints(
                                  Offset(overlay.size.width - 56.w, 80.h),
                                  Offset(overlay.size.width - 16.w, 120.h),
                                ),
                                Offset.zero & overlay.size,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              items: [
                                const PopupMenuItem(
                                  value: 'en',
                                  child: Text('English'),
                                ),
                                const PopupMenuItem(
                                  value: 'de',
                                  child: Text('German'),
                                ),
                              ],
                            );

                            if (selected != null) {
                              if (selected == 'en') {
                                _languageController.changeLanguage("English");
                              } else if (selected == 'de') {
                                _languageController.changeLanguage("German");
                              }
                            }
                          },
                          child: Container(
                            height: 24.h,
                            width: 24.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Image.asset(
                              Assets.icons.language.path,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                Gap(24.h),

                // Monthly Report Card
                InkWell(
                  onTap: () {
                    context.push(RoutePath.report.addBasePath);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40FFD673),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '25 April, 2025',
                              style: AppStyle.roboto12w400C5A5A5A,
                            ),
                            Gap(8.h),
                            Text(
                              AppStrings.monthlyReport.tr,
                              style: AppStyle.roboto16w400C000000,
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor:
                              const Color(0xFF0000000).withOpacity(0.05),
                          child: Image.asset(
                            Assets.icons.graph.path,
                            height: 48.h,
                            width: 48.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Gap(24.h),

                // Monthly Grocery Spending Section (Fixed with Flexible + AutoSizeText)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            AppStrings.monthlyGrocerySpending.tr,
                            style: AppStyle.kohSantepheap18w400C000000,
                            maxLines: 2,
                            minFontSize: 8,
                          ),
                          AutoSizeText(
                            AppStrings.totalExpenses.tr,
                            style: AppStyle.roboto12w400C80000000,
                            maxLines: 1,
                            minFontSize: 6,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Your onPressed logic here
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 36.h,
                        width: 106.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: AppColors.yellowFFD673,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                AppStrings.viewBreakdown.tr,
                                style: AppStyle.roboto10w400C000000,
                                maxLines: 1,
                                minFontSize: 6,
                              ),
                            ),
                            Gap(4.w),
                            SvgPicture.asset(
                              Assets.icons.forwardView.path,
                              height: 12.h,
                              width: 12.w,
                              color: const Color(0xff000000).withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                Gap(8.h),

                SizedBox(
                  height: 189.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9D976),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.sales.path,
                                      color: Colors.black,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.star.path,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    // <-- Wrap this Column with Flexible
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          AppStrings.totalSpent.tr,
                                          style: AppStyle.roboto16w500C000000,
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                        AutoSizeText(
                                          AppStrings.trackTotalSpent.tr,
                                          style: AppStyle.roboto10w500C80000000,
                                          maxLines: 1,
                                          minFontSize: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  AutoSizeText(
                                    '\$2800',
                                    style: AppStyle.roboto14w500C000000,
                                    maxLines: 1,
                                    minFontSize: 10,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    AppStrings.add.tr,
                                    style: AppStyle.roboto12w400C000000,
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.plus.path,
                                      color: Colors.black,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4DFD7),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.coin.path,
                                      color: Colors.black,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.star.path,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        AppStrings.budgetLimit.tr,
                                        style: AppStyle.roboto16w500C000000,
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                      AutoSizeText(
                                        AppStrings.underBudget.tr,
                                        style: AppStyle.roboto10w500C80000000,
                                        maxLines: 1,
                                        minFontSize: 6,
                                      ),
                                    ],
                                  ),
                                  AutoSizeText(
                                    '\$3000',
                                    style: AppStyle.roboto14w500C000000,
                                    maxLines: 1,
                                    minFontSize: 10,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    AppStrings.add.tr,
                                    style: AppStyle.roboto12w400C000000,
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: Image.asset(
                                      Assets.icons.plus.path,
                                      color: Colors.black,
                                      height: 26.h,
                                      width: 26.w,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(24.h),

                // Recent Purchases horizontal scroll
                Text(
                  AppStrings.recentPurchases.tr,
                  style: AppStyle.kohSantepheap18w400C000000,
                ),
                Gap(12.h),
                SizedBox(
                  height: 210.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      purchaseCard(
                        category: 'Dairy',
                        name: 'Milk',
                        price: '\$8.50',
                        imageUrl: Assets.images.dairy.path,
                      ),
                      purchaseCard(
                        category: 'Meat',
                        name: 'Chicken Breast',
                        price: '\$8.50',
                        imageUrl: Assets.images.meat.path,
                      ),
                      purchaseCard(
                        category: 'Vegetables',
                        name: 'Broccoli',
                        price: '\$2.00',
                        imageUrl: Assets.images.brocoli.path,
                      ),
                    ],
                  ),
                ),

                Gap(24.h),

                // Purchase History Header (Fixed with Flexible + AutoSizeText)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            AppStrings.purchaseHistory.tr,
                            style: AppStyle.kohSantepheap18w400C000000,
                            maxLines: 2,
                            minFontSize: 8,
                          ),
                          AutoSizeText(
                            AppStrings.itemsYouveBought.tr,
                            style: AppStyle.roboto12w400C80000000,
                            maxLines: 1,
                            minFontSize: 6,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Your onPressed logic here
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 22.h,
                        width: 69.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: AppColors.yellowFFD673,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                AppStrings.viewAll.tr,
                                style: AppStyle.roboto12w400C000000,
                                maxLines: 1,
                                minFontSize: 6,
                              ),
                            ),
                            Gap(4.w),
                            SvgPicture.asset(
                              Assets.icons.forwardView.path,
                              height: 12.h,
                              width: 12.w,
                              color: const Color(0xff000000).withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    purchaseHistoryItem(
                      'Milk',
                      'Dairy',
                      '\$2.50',
                      Assets.icons.milk.path,
                    ),
                    purchaseHistoryItem(
                      'Bread',
                      'Bakery',
                      '\$1.80',
                      Assets.icons.bread.path,
                    ),
                    purchaseHistoryItem(
                      'Apples',
                      'Fruits',
                      '\$3.00',
                      Assets.icons.apples.path,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget purchaseCard({
    required String category,
    required String name,
    required String price,
    required String imageUrl,
  }) {
    return Container(
      width: 148.w,
      height: 210.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 150.h,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Gap(6.h),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              alignment: Alignment.topLeft,
              child: Container(
                height: 24.h,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                ),
                child: Text(
                  category,
                  style: AppStyle.roboto12w500C000000,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5.h,
            left: 15.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStyle.roboto12w400C000000,
                ),
                Text(
                  price,
                  style: AppStyle.roboto16w500C000000,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget purchaseHistoryItem(
    String item,
    String category,
    String price,
    String imageUrl,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset(
            imageUrl,
            height: 24.h,
            width: 24.w,
          ),
          title: Text(
            item,
            style: AppStyle.roboto14w400C000000,
          ),
          subtitle: Text(
            category,
            style: AppStyle.roboto12w400C80000000,
          ),
          trailing: Text(
            price,
            style: AppStyle.roboto14w500C000000,
          ),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        Divider(
          color: Colors.black.withOpacity(0.1),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
