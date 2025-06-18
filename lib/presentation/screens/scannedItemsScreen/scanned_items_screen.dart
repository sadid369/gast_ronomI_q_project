// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:groc_shopy/core/routes/route_path.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../global/model/receipt_Item.dart';
// import '../../../utils/app_colors/app_colors.dart';
// import '../../../utils/static_strings/static_strings.dart';
// import '../../../utils/text_style/text_style.dart';
// import 'package:gap/gap.dart';
// import '../../widgets/custom_navbar/navbar_controller.dart';
// import 'scanned_items_controller/scanned_items_controller.dart'; // add this

// class ScannedItemsScreen extends StatefulWidget {
//   final Map<String, dynamic> extras;
//   const ScannedItemsScreen({Key? key, required this.extras}) : super(key: key);

//   @override
//   State<ScannedItemsScreen> createState() => _ScannedItemsScreenState();
// }

// class _ScannedItemsScreenState extends State<ScannedItemsScreen> {
//   final BottomNavController navigationController =
//       Get.find<BottomNavController>();
//   final ScannedItemsController ctrl =
//       Get.put(ScannedItemsController()); // inject

//   @override
//   void initState() {
//     super.initState();
//     // controller.fetchReceiptAndItems() runs automatically in onInit()
//   }

//   @override
//   Widget build(BuildContext context) {
//     final File? image = widget.extras['image'];

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             children: [
//               _buildHeader(context),
//               Gap(16.h),
//               _buildImagePreview(image),
//               Gap(12.h),
//               _buildRecentScansHeader(),
//               Gap(8.h),

//               // <-- replace manual list with Obx()
//               Expanded(
//                 child: Obx(() {
//                   if (ctrl.isLoading) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             AppColors.yellowFFD673),
//                       ),
//                     );
//                   }
//                   if (ctrl.error.isNotEmpty) {
//                     return Center(
//                       child: Text(
//                         ctrl.error,
//                         style: AppStyle.roboto14w400C000000,
//                         textAlign: TextAlign.center,
//                       ),
//                     );
//                   }
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 16.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: ListView.separated(
//                       padding: EdgeInsets.all(12.w),
//                       itemCount: ctrl.items.length,
//                       separatorBuilder: (_, __) => Divider(
//                         height: 24.h,
//                         color: Colors.grey.shade300,
//                       ),
//                       itemBuilder: (context, index) {
//                         final item = ctrl.items[index];
//                         return _buildItemRow(item);
//                       },
//                     ),
//                   );
//                 }),
//               ),

//               Gap(16.h),
//               _buildActionButtons(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       color: AppColors.backgroundColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               navigationController.selectedIndex(1);
//               context.pop();
//             },
//             child: Image.asset(
//               Assets.icons.arrowBackGrey.path,
//               width: 24.w,
//               height: 24.h,
//             ),
//           ),
//           Text(
//             AppStrings.groceryItems.tr,
//             style: AppStyle.kohSantepheap16w700C3F3F3F,
//           ),
//           Icon(Icons.more_horiz, color: Colors.grey, size: 24.sp),
//         ],
//       ),
//     );
//   }

//   Widget _buildImagePreview(File? image) {
//     return Container(
//       height: 230.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//         image: image != null
//             ? DecorationImage(
//                 image: FileImage(image),
//                 fit: BoxFit.cover,
//               )
//             : DecorationImage(
//                 image: AssetImage(Assets.images.invoicePlaceholder.path),
//                 fit: BoxFit.cover,
//               ),
//       ),
//     );
//   }

//   Widget _buildRecentScansHeader() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         AppStrings.recentScans.tr,
//         style: AppStyle.roboto14w500C000000,
//       ),
//     );
//   }

//   Widget _buildItemRow(ReceiptItem item) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 20.r,
//               backgroundColor: const Color(0xFFF2F2F2),
//               child: Icon(
//                 Icons.shopping_cart_outlined,
//                 color: Colors.orange.shade200,
//                 size: 24.sp,
//               ),
//             ),
//             Gap(10.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.product,
//                   style: AppStyle.roboto14w400C000000,
//                 ),
//                 Text(
//                   item.date,
//                   style: AppStyle.roboto10w400C80000000,
//                 ),
//                 Text(
//                   "\$${item.amount.toStringAsFixed(2)}",
//                   style: AppStyle.roboto10w400CFFD673,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: 70.w,
//           height: 28.h,
//           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//           decoration: BoxDecoration(
//             color: Colors.orange.shade200,
//             borderRadius: BorderRadius.circular(24.r),
//           ),
//           child: Text(
//             item.status.tr,
//             style: AppStyle.roboto8w500C000000,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CustomOutlinedButton(
//           width: 86.w,
//           height: 32.h,
//           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//           text: AppStrings.edit.tr,
//           onPressed: () {
//             context.pop();
//           },
//         ),
//         Gap(20.w),
//         CustomOutlinedButton(
//           borderColor: Colors.black,
//           textColor: Colors.white,
//           backgroundColor: AppColors.yellowFFD673,
//           width: 86.w,
//           height: 32.h,
//           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//           text: AppStrings.save.tr,
//           onPressed: () {
//             context.pop();
//           },
//         ),
//       ],
//     );
//   }
// }

// class CustomOutlinedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color borderColor;
//   final Color textColor;
//   final Color backgroundColor;
//   final EdgeInsetsGeometry padding;
//   final double borderRadius;
//   final double? width;
//   final double? height;

//   const CustomOutlinedButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.borderColor = Colors.black,
//     this.textColor = Colors.black,
//     this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//     this.backgroundColor = Colors.transparent,
//     this.borderRadius = 30,
//     this.width,
//     this.height,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: width,
//         height: height,
//         padding: padding,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           border: Border.all(color: borderColor, width: 1.w),
//           borderRadius: BorderRadius.circular(borderRadius.r),
//         ),
//         child: Text(
//           text,
//           style: AppStyle.inter14w700CFFFFFF.copyWith(
//             color: textColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:groc_shopy/helper/extension/base_extension.dart';
import 'package:http/http.dart' as http;
import 'package:groc_shopy/core/routes/route_path.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';
import 'package:gap/gap.dart';
import '../../widgets/custom_navbar/navbar_controller.dart';
import '../home/controller/home_controller.dart';
import '../transaction_history/transaction_history_controller/transaction_history_controller.dart';

class ReceiptItem {
  final String date;
  final String product;
  final String category;
  final double amount;
  final String status;

  ReceiptItem({
    required this.date,
    required this.product,
    required this.category,
    required this.amount,
    this.status = "Processed",
  });

  // no longer used; we'll construct from receipt + item JSON
  factory ReceiptItem.fromJson(Map<String, dynamic> json, String date) {
    return ReceiptItem(
      date: date,
      product: json['item_name'] ?? '',
      category: json['category'] ?? '',
      amount: (json['price'] ?? 0.0).toDouble(),
    );
  }
}

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
  List<ReceiptItem> scannedItems = [];
  bool isLoading = true;
  String errorMessage = '';

  // API endpoint (returns a single receipt with items[])
  final String _receiptUrl = 'http://10.0.70.145:8001/report/orders/recent/';

  @override
  void initState() {
    super.initState();
    _fetchReceiptAndItems();
  }

  // … existing imports …

  Future<void> _fetchReceiptAndItems() async {
    // define your token as a const here
    const String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNzk4Mjg3LCJpYXQiOjE3NTAyMDYyODcsImp0aSI6IjU4ZjZlNWZmYmUzZDRjN2VhNTA0NGE5NmI5MWNjMTEyIiwidXNlcl9pZCI6NjF9.g7CJStsIGf_nMQsVdjLJmiilcC59jnq5yloneCB0K7Q';

    try {
      final response = await http.get(
        Uri.parse(_receiptUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('GET $_receiptUrl → ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await ctrl.fetchRecentOrders();
        await transController.fetchHistory();
        final Map<String, dynamic> data = json.decode(response.body);
        final String createdAt = data['created_at'] ?? '';
        final itemsJson = data['items'] as List<dynamic>;
        setState(() {
          scannedItems = itemsJson
              .map((j) =>
                  ReceiptItem.fromJson(j as Map<String, dynamic>, createdAt))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load receipt: '
              '${response.statusCode}\n${response.body}';
          isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Fetch error: $e\n$st');
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final File? image = widget.extras['image'];

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
    if (isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowFFD673),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            errorMessage,
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
          itemCount: scannedItems.length,
          separatorBuilder: (_, __) => Divider(
            height: 24.h,
            color: Colors.grey.shade300,
          ),
          itemBuilder: (context, index) {
            final item = scannedItems[index];
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
