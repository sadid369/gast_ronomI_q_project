import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart'; // <-- for .tr
import 'package:groc_shopy/core/custom_assets/assets.gen.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';

class TransactionHistoryScreen extends StatelessWidget {
  TransactionHistoryScreen({super.key});
  final Color backgroundColor = const Color(0xFFF8F4ED);
  final Color lightGray = const Color(0xFFD9D9D9);
  final Color darkGray = const Color(0xFF858585);

  final List<TransactionGroup> transactions = [
    TransactionGroup(
      date: 'Today, 14 May, 2025', // Consider translating if dynamic
      total: 1060,
      items: [
        TransactionItem(
          title: 'Dairy'.tr,
          subtitle: 'Today'.tr,
          amount: 120,
          icon: Assets.icons.dairy.path,
        ),
        TransactionItem(
          title: 'Meat'.tr,
          subtitle: 'Today'.tr,
          amount: 800,
          icon: Assets.icons.meat.path,
        ),
        TransactionItem(
          title: 'Vegetables'.tr,
          subtitle: 'Today'.tr,
          amount: 140,
          icon: Assets.icons.vegetables.path,
        ),
      ],
    ),
    TransactionGroup(
      date: 'Yesterday, 13 May, 2025', // Consider translating if dynamic
      total: 500,
      items: [
        TransactionItem(
          title: 'Fruits'.tr,
          subtitle: 'Yesterday'.tr,
          amount: 66,
          icon: Assets.icons.fruits.path,
        ),
        TransactionItem(
          title: 'Drinks'.tr,
          subtitle: 'Yesterday'.tr,
          amount: 300,
          icon: Assets.icons.drinks.path,
        ),
        TransactionItem(
          title: 'Plates'.tr,
          subtitle: 'Yesterday'.tr,
          amount: 134,
          icon: Assets.icons.plates.path,
        ),
      ],
    ),
    TransactionGroup(
      date: 'Yesterday, 13 May, 2025', // Consider translating if dynamic
      total: 500,
      items: [
        TransactionItem(
          title: 'Packaging'.tr,
          subtitle: 'Yesterday'.tr,
          amount: 66,
          icon: Assets.icons.packaging.path,
        ),
        TransactionItem(
          title: 'Drinks'.tr,
          subtitle: 'Yesterday'.tr,
          amount: 300,
          icon: Assets.icons.drinks.path,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: AppColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      AppStrings.transactionHistory.tr,
                      style: AppStyle.kohSantepheap16w700C3F3F3F,
                    ),
                    Icon(Icons.more_horiz, color: Colors.grey, size: 24.sp),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 82.h,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD673).withOpacity(0.25),
                      offset: Offset(0, 4.h),
                      blurRadius: 4.r,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.totalSpending.tr,
                      style: AppStyle.roboto16w600C80000000,
                    ),
                    const Spacer(),
                    Text(
                      '\$1920',
                      style: AppStyle.roboto24w500CFFD673,
                    ),
                  ],
                ),
              ),
              // Export & Download Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _smallButton(AppStrings.export.tr),
                  Gap(12.w),
                  _smallButton(AppStrings.download.tr),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final group = transactions[index];
                    return _buildTransactionGroup(group);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallButton(String label) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        label,
        style: AppStyle.inter12w500CB2000000,
      ),
    );
  }

  Widget _buildTransactionGroup(TransactionGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: lightGray,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          margin: EdgeInsets.only(top: 7.h),
          child: Row(
            children: [
              Text(
                group.date,
                style: AppStyle.roboto12w600C80000000,
              ),
              const Spacer(),
              Text(
                '\$${group.total}',
                style: AppStyle.roboto12w600CFFD673,
              ),
            ],
          ),
        ),
        ...group.items.map((item) => _buildTransactionItem(item)).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionItem item) {
    return Container(
      padding: EdgeInsets.all(10.w),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F2),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(4.w),
            child: SvgPicture.asset(
              item.icon,
            ),
          ),
          Gap(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppStyle.roboto16w400C000000,
              ),
              Gap(6.h),
              Text(
                item.subtitle,
                style: AppStyle.roboto10w400C80000000,
              ),
            ],
          ),
          const Spacer(),
          Text(
            '\$${item.amount}',
            style: AppStyle.roboto16w500CFFD673,
          ),
        ],
      ),
    );
  }
}

class TransactionGroup {
  final String date;
  final int total;
  final List<TransactionItem> items;

  TransactionGroup({
    required this.date,
    required this.total,
    required this.items,
  });
}

class TransactionItem {
  final String title;
  final String subtitle;
  final int amount;
  final String icon;

  TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
  });
}
