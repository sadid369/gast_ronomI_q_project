import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/static_strings/static_strings.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';

import '../../../global/model/transaction_history.dart';
import 'controller/transaction_history_controller.dart';

class TransactionHistoryScreen extends StatelessWidget {
  TransactionHistoryScreen({Key? key}) : super(key: key);
  final controller = Get.find<TransactionHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value != null) {
        return Center(
          child: Text('Error: ${controller.errorMessage.value}'),
        );
      }
      final history = controller.history.value!;
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
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
                      Text(AppStrings.totalSpending.tr,
                          style: AppStyle.roboto16w600C80000000),
                      const Spacer(),
                      Text('\$${history.totalSpending}',
                          style: AppStyle.roboto24w500CFFD673),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     _smallButton(AppStrings.export.tr),
                //     Gap(12.w),
                //     _smallButton(AppStrings.download.tr),
                //   ],
                // ),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.transactions.length,
                    itemBuilder: (_, i) =>
                        _buildTransactionGroup(history.transactions[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTransactionGroup(Transaction tx) {
    final dateStr = tx.date.toIso8601String().split('T').first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: const Color(0xFFD9D9D9),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          margin: EdgeInsets.only(top: 7.h),
          child: Row(
            children: [
              Text(dateStr, style: AppStyle.roboto12w600C80000000),
              const Spacer(),
              Text('\$${tx.total}', style: AppStyle.roboto12w600CFFD673),
            ],
          ),
        ),
        ...tx.items.map(_buildTransactionItem).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Item item) {
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
          ),
          Gap(12.w),
          Text(item.name, style: AppStyle.roboto16w400C000000),
          const Spacer(),
          Text('\$${item.amount}', style: AppStyle.roboto16w500CFFD673),
        ],
      ),
    );
  }

  Widget _smallButton(String label) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(label, style: AppStyle.inter12w500CB2000000),
    );
  }
}
