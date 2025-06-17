import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:groc_shopy/utils/text_style/text_style.dart';

class PurchaseCard extends StatelessWidget {
  final String category;
  final String name;
  final String price;
  final String imageUrl;

  const PurchaseCard({
    Key? key,
    required this.category,
    required this.name,
    required this.price,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Image.network(
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
}
