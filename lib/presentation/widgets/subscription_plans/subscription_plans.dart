import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:groc_shopy/utils/app_colors/app_colors.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';
import 'package:gap/gap.dart';

// import '../../../models/subscription_plan_model.dart';
import '../../../core/routes/route_path.dart';
import '../../../global/model/subscription_plan.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../widgets/custom_bottons/custom_button/app_button.dart';

class SubscriptionPlansBottomSheet extends StatefulWidget {
  final List<SubscriptionPlan> plans;
  final void Function(SubscriptionPlan selectedPlan) onSubscribe;

  const SubscriptionPlansBottomSheet({
    super.key,
    required this.plans,
    required this.onSubscribe,
  });

  @override
  State<SubscriptionPlansBottomSheet> createState() =>
      _SubscriptionPlansBottomSheetState();
}

class _SubscriptionPlansBottomSheetState
    extends State<SubscriptionPlansBottomSheet> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with cancel button
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  // if (Navigator.of(context).canPop()) {
                  //   Navigator.of(context).pop();
                  // } else {
                  //   // Fallback navigation if sheet can't be popped
                  //   context.go(RoutePath.home.addBasePath);
                  // }
                  context.go(RoutePath.home.addBasePath);
                },
                child: Text(
                  AppStrings.cancel.tr,
                  style: AppStyle.roboto12w700CFFD673,
                ),
              ),
            ),

            // Title
            Text(
              AppStrings.getUnlimitedAccess.tr,
              style: AppStyle.kohSantepheap16w700C090A0A,
              textAlign: TextAlign.center,
            ),
            Gap(6.h),

            // Subtitle
            SizedBox(
              width: 218.w,
              child: Text(
                AppStrings.takeFirstStep.tr,
                style: AppStyle.roboto12w400C090A0A,
                textAlign: TextAlign.center,
              ),
            ),
            Gap(20.h),

            // Plan Cards
            ...widget.plans.map((plan) {
              final index = widget.plans.indexOf(plan);
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: PlanCard(
                  title: plan.name,
                  price: plan.price,
                  priceSuffix: plan.durationDays == 30
                      ? '/month'
                      : '/${plan.durationDays} days',
                  features: [
                    'Premium features unlocked',
                    'Duration: ${plan.durationDays} days',
                  ],
                  isHighlighted: selectedIndex == index,
                ),
              );
            }).toList(),

            Gap(6.h),

            // Subscribe Button
            AppButton(
              text: AppStrings.subscribe.tr,
              onPressed: selectedIndex != null
                  ? () {
                      widget.onSubscribe(widget.plans[selectedIndex!]);
                      Navigator.of(context).pop();
                    }
                  : null,
              width: 263.w,
              height: 48.h,
              backgroundColor: const Color(0xFFFBC964),
              borderRadius: 30.r,
              textStyle: AppStyle.inter16w700CFFFFFF,
              enabled: selectedIndex != null,
            ),

            Gap(24.h),

            // Pricing Info
            Text(
              AppStrings.pricingInfo.tr,
              style: AppStyle.inter12w400C090A0A,
              textAlign: TextAlign.center,
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String priceSuffix;
  final List<String> features;
  final bool isHighlighted;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.priceSuffix,
    required this.features,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isHighlighted ? AppColors.yellowFFD673 : Colors.black.withAlpha(26);
    final backgroundColor = isHighlighted ? Colors.white : Colors.transparent;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: backgroundColor,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr,
            style: AppStyle.roboto16w500C090A0A,
          ),
          Gap(8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: AppStyle.roboto14w700CFFD673,
                ),
                TextSpan(
                  text: priceSuffix,
                  style: AppStyle.roboto14w400C090A0A,
                ),
              ],
            ),
          ),
          Gap(12.h),
          ...features
              .map(
                (feature) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box_outlined,
                        color: const Color(0xFFFBC964),
                        size: 15.sp,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          feature.tr,
                          style: AppStyle.roboto12w400C000000,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
