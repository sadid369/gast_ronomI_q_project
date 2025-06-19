import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:gap/gap.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';
import '../../widgets/custom_navbar/navbar_controller.dart';
import '../home/controller/home_controller.dart';
import '../transaction_history/controller/transaction_history_controller.dart';
import 'controller/scanned_items_controller.dart';

class ScannedItemsScreen extends StatefulWidget {
  final Map<String, dynamic> extras;

  const ScannedItemsScreen({Key? key, required this.extras}) : super(key: key);

  @override
  State<ScannedItemsScreen> createState() => _ScannedItemsScreenState();
}

class _ScannedItemsScreenState extends State<ScannedItemsScreen> {
  final BottomNavController controller = Get.find<BottomNavController>();
  final HomeController ctrl = Get.find<HomeController>();
  final transController = Get.find<TransactionHistoryController>();

  late final ScannedItemsController scannedItemsController;

  @override
  void initState() {
    super.initState();
    scannedItemsController = ScannedItemsController();
    scannedItemsController.fetchReceiptAndItems().then((_) async {
      await ctrl.fetchRecentOrders();
      await transController.fetchHistory();
    });
  }

  @override
  void dispose() {
    scannedItemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final File? image = widget.extras['image'];

    return AnimatedBuilder(
      animation: scannedItemsController,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildHeader(context),
                  Gap(16.h),
                  _buildImagePreview(image),
                  Gap(12.h),
                  _buildRecentScansHeader(),
                  Gap(8.h),
                  _buildItemsList(),
                  Gap(16.h),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              controller.selectedIndex(1);
              context.pop();
            },
            child: Image.asset(
              Assets.icons.arrowBackGrey.path,
              width: 24.w,
              height: 24.h,
            ),
          ),
          Text(
            AppStrings.groceryItems.tr,
            style: AppStyle.kohSantepheap16w700C3F3F3F,
          ),
          Icon(Icons.more_horiz, color: Colors.grey, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildImagePreview(File? image) {
    return Container(
      height: 230.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        image: image != null
            ? DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: AssetImage(Assets.images.invoicePlaceholder.path),
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildRecentScansHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        AppStrings.recentScans.tr,
        style: AppStyle.roboto14w500C000000,
      ),
    );
  }

  Widget _buildItemsList() {
    if (scannedItemsController.isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowFFD673),
          ),
        ),
      );
    }

    if (scannedItemsController.errorMessage.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            scannedItemsController.errorMessage,
            style: AppStyle.roboto14w400C000000,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListView.separated(
          padding: EdgeInsets.all(12.w),
          itemCount: scannedItemsController.scannedItems.length,
          separatorBuilder: (_, __) => Divider(
            height: 24.h,
            color: Colors.grey.shade300,
          ),
          itemBuilder: (context, index) {
            final item = scannedItemsController.scannedItems[index];
            return _buildItemRow(item);
          },
        ),
      ),
    );
  }

  Widget _buildItemRow(ReceiptItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFFF2F2F2),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.orange.shade200,
                size: 24.sp,
              ),
            ),
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product,
                  style: AppStyle.roboto14w400C000000,
                ),
                Text(
                  item.date,
                  style: AppStyle.roboto10w400C80000000,
                ),
                Text(
                  "\$${item.amount.toStringAsFixed(2)}",
                  style: AppStyle.roboto10w400CFFD673,
                ),
              ],
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          width: 70.w,
          height: 28.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.orange.shade200,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Text(
            item.status.tr,
            style: AppStyle.roboto8w500C000000,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomOutlinedButton(
          width: 86.w,
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          text: AppStrings.edit.tr,
          onPressed: () {
            context.pop();
          },
        ),
        Gap(20.w),
        CustomOutlinedButton(
          borderColor: Colors.black,
          textColor: Colors.white,
          backgroundColor: AppColors.yellowFFD673,
          width: 86.w,
          height: 32.h,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          text: AppStrings.save.tr,
          onPressed: () {
            context.go(RoutePath.home.addBasePath);
          },
        ),
      ],
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;
  final double? height;

  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 30,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.w),
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Text(
          text,
          style: AppStyle.inter14w700CFFFFFF.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
