import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';

class PurchaseHistoryItem extends StatelessWidget {
  final String item;
  final String category;
  final String price;
  final String imageUrl;

  const PurchaseHistoryItem({
    Key? key,
    required this.item,
    required this.category,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.network(
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
