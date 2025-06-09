import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<String> icons;
  final List<String> labels; // Made labels required for this design

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    // Use the flexible lists but provide your asset paths as defaults
    this.icons = const [
      'assets/icons/home.svg', // Replaced with Assets.gen for type safety
      'assets/icons/scan.svg',
      'assets/icons/transaction.svg',
      'assets/icons/profile.svg',
    ],
    this.labels = const [
      'Home',
      'Scan',
      'History',
      'Profile',
    ],
  });

  @override
  Widget build(BuildContext context) {
    // These are the active/inactive colors from your first example
    const activeColor = Color(0xFFFFD54F);
    const inactiveColor = Color(0xFFC4C4C4);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xff282f291a).withOpacity(0.1),
        borderRadius: BorderRadius.circular(50.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        // Use spaceBetween for the expanding animation to work correctly
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              // Animation values from your first example
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isSelected ? 150.w : 65.w,
              height: 65.h,
              decoration: BoxDecoration(
                // Colors and border radius from your first example
                color: isSelected ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(isSelected ? 25.r : 50.r),
              ),
              alignment: Alignment.center,
              // Use a Row to show the label only when selected
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    icons[index],
                    // No color filter, to use the icon's original colors
                  ),
                  // Conditionally show the label with a fade animation
                  if (isSelected)
                    AnimatedOpacity(
                      opacity: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        // child: Text(
                        //   labels[index],
                        //   style: TextStyle(
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.bold,
                        //     // Use a dark color for readability on the yellow background
                        //     color: Colors.black.withOpacity(0.8),
                        //   ),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
