import 'package:auto_size_text/auto_size_text.dart';
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
import '../../widgets/purchase_card/purchase_card.dart';
import '../../widgets/purchase_history_item/purchase_history_item.dart';
import '../../widgets/subscription_plans/subscription_plans.dart';
import '../../widgets/subscription_modal/subscription_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LanguageController _languageController = Get.find();

  @override
  void initState() {
    super.initState();
    _showSubscriptionModal();
  }

  void _showSubscriptionModal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const SubscriptionModal(),
      );
    });
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
                _buildHeader(),
                Gap(24.h),
                _buildMonthlyReportCard(),
                Gap(24.h),
                _buildMonthlyGrocerySpendingSection(),
                Gap(8.h),
                _buildExpensesCards(),
                Gap(24.h),
                _buildRecentPurchasesSection(),
                Gap(24.h),
                _buildPurchaseHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildIconButton(Assets.icons.shop.path),
        Gap(6.w),
        GestureDetector(
          onTap: _showLanguageMenu,
          child: _buildIconButton(Assets.icons.language.path),
        ),
      ],
    );
  }

  Widget _buildIconButton(String iconPath) {
    return Container(
      height: 24.h,
      width: 24.w,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Image.asset(
        iconPath,
        height: 24.h,
        width: 24.w,
      ),
    );
  }

  Future<void> _showLanguageMenu() async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

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
      _languageController
          .changeLanguage(selected == 'en' ? "English" : "German");
    }
  }

  Widget _buildMonthlyReportCard() {
    return InkWell(
      onTap: () => context.push(RoutePath.report.addBasePath),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
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
              backgroundColor: const Color(0xFF0000000).withOpacity(0.05),
              child: Image.asset(
                Assets.icons.graph.path,
                height: 48.h,
                width: 48.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyGrocerySpendingSection() {
    return Row(
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
        _buildViewBreakdownButton(),
      ],
    );
  }

  Widget _buildViewBreakdownButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildExpensesCards() {
    return SizedBox(
      height: 189.h,
      child: Row(
        children: [
          Expanded(
            child: _buildExpenseCard(
              backgroundColor: const Color(0xFFF9D976),
              iconPath: Assets.icons.sales.path,
              title: AppStrings.totalSpent.tr,
              subtitle: AppStrings.trackTotalSpent.tr,
              amount: '\$2800',
            ),
          ),
          Gap(12.w),
          Expanded(
            child: _buildExpenseCard(
              backgroundColor: const Color(0xFFE4DFD7),
              iconPath: Assets.icons.coin.path,
              title: AppStrings.budgetLimit.tr,
              subtitle: AppStrings.underBudget.tr,
              amount: '\$3000',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard({
    required Color backgroundColor,
    required String iconPath,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircularIcon(iconPath, Colors.black),
              _buildCircularIcon(Assets.icons.star.path, null),
            ],
          ),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      title,
                      style: AppStyle.roboto16w500C000000,
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                    AutoSizeText(
                      subtitle,
                      style: AppStyle.roboto10w500C80000000,
                      maxLines: 1,
                      minFontSize: 6,
                    ),
                  ],
                ),
              ),
              AutoSizeText(
                amount,
                style: AppStyle.roboto14w500C000000,
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                AppStrings.add.tr,
                style: AppStyle.roboto12w400C000000,
                maxLines: 1,
                minFontSize: 8,
              ),
              _buildCircularIcon(Assets.icons.plus.path, Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(String iconPath, Color? iconColor) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 20.r,
      child: Image.asset(
        iconPath,
        color: iconColor,
        height: 26.h,
        width: 26.w,
      ),
    );
  }

  Widget _buildRecentPurchasesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              PurchaseCard(
                category: 'Dairy',
                name: 'Milk',
                price: '\$8.50',
                imageUrl: Assets.images.dairy.path,
              ),
              PurchaseCard(
                category: 'Meat',
                name: 'Chicken Breast',
                price: '\$8.50',
                imageUrl: Assets.images.meat.path,
              ),
              PurchaseCard(
                category: 'Vegetables',
                name: 'Broccoli',
                price: '\$2.00',
                imageUrl: Assets.images.brocoli.path,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPurchaseHistoryHeader(),
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            PurchaseHistoryItem(
              item: 'Milk',
              category: 'Dairy',
              price: '\$2.50',
              imageUrl: Assets.icons.milk.path,
            ),
            PurchaseHistoryItem(
              item: 'Bread',
              category: 'Bakery',
              price: '\$1.80',
              imageUrl: Assets.icons.bread.path,
            ),
            PurchaseHistoryItem(
              item: 'Apples',
              category: 'Fruits',
              price: '\$3.00',
              imageUrl: Assets.icons.apples.path,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPurchaseHistoryHeader() {
    return Row(
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
        _buildViewAllButton(),
      ],
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
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
    );
  }
}
