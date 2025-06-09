// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/custom_assets/assets.gen.dart';
// import '../../../utils/app_colors/app_colors.dart';
// import '../../../utils/static_strings/static_strings.dart';
// import '../../../utils/text_style/text_style.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   int displayedYear = 2025;
//   int displayedMonth = 1;

//   final List<String> weekdays = const [
//     'Sun',
//     'Mon',
//     'Tue',
//     'Wed',
//     'Thu',
//     'Fri',
//     'Sat'
//   ];

//   final Map<String, double> dataMap = {
//     "Diary": 22,
//     "Meat": 40,
//     "Vegetables": 23,
//     "Others": 15,
//   };

//   final List<Color> colorList = const [
//     Color(0xFFDDDDDD),
//     Color(0xFFCF8989),
//     Color(0xFF9ACF89),
//     Color(0xFF89B4CF),
//   ];

//   void _goToPreviousMonth() {
//     setState(() {
//       if (displayedMonth == 1) {
//         displayedMonth = 12;
//         displayedYear--;
//       } else {
//         displayedMonth--;
//       }
//     });
//   }

//   void _goToNextMonth() {
//     setState(() {
//       if (displayedMonth == 12) {
//         displayedMonth = 1;
//         displayedYear++;
//       } else {
//         displayedMonth++;
//       }
//     });
//   }

//   int _daysInMonth(int year, int month) {
//     final firstDayThisMonth = DateTime(year, month, 1);
//     final firstDayNextMonth =
//         (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
//     return firstDayNextMonth.difference(firstDayThisMonth).inDays;
//   }

//   int _firstWeekdayOfMonth(int year, int month) {
//     int weekday = DateTime(year, month, 1).weekday;
//     return weekday % 7;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final daysInMonth = _daysInMonth(displayedYear, displayedMonth);
//     final startWeekday = _firstWeekdayOfMonth(displayedYear, displayedMonth);

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 color: AppColors.backgroundColor,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         context.pop();
//                       },
//                       child: Image.asset(
//                         Assets.icons.arrowBackGrey.path,
//                         width: 24.w,
//                         height: 24.h,
//                       ),
//                     ),
//                     Text(
//                       AppStrings.report,
//                       style: AppStyle.kohSantepheap16w700C3F3F3F,
//                     ),
//                     Icon(Icons.more_horiz, color: Colors.grey, size: 24.sp),
//                   ],
//                 ),
//               ),
//               Gap(12.h),
//               // Month and Year with navigation buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.chevron_left, size: 18.sp),
//                     onPressed: _goToPreviousMonth,
//                   ),
//                   Text(
//                     "${_monthName(displayedMonth)} $displayedYear",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.chevron_right, size: 18.sp),
//                     onPressed: _goToNextMonth,
//                   ),
//                 ],
//               ),
//               Gap(8.h),
//               // Weekday header row
//               Table(
//                 border: TableBorder.all(color: Colors.black54, width: 1.w),
//                 children: [
//                   TableRow(
//                     decoration: BoxDecoration(color: Colors.grey.shade300),
//                     children: weekdays
//                         .map((day) => Padding(
//                               padding: EdgeInsets.all(6.w),
//                               child: Center(
//                                 child: Text(
//                                   day,
//                                   style: GoogleFonts.inter(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.sp,
//                                   ),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   ),
//                 ],
//               ),
//               // Calendar days grid
//               Table(
//                 border: TableBorder.all(color: Colors.black54, width: 1.w),
//                 children: _buildCalendarRows(startWeekday, daysInMonth),
//               ),
//               Gap(20.h),
//               // Report title
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Report of Month ${_monthName(displayedMonth)} $displayedYear",
//                   style: GoogleFonts.inter(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//               ),
//               Gap(10.h),
//               // Pie chart and legend side by side
//               SizedBox(
//                 height: MediaQuery.of(context).size.width / 2,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Pie Chart
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width / 2,
//                       height: MediaQuery.of(context).size.width / 2,
//                       child: PieChart(
//                         PieChartData(
//                           sectionsSpace: 5.w,
//                           centerSpaceRadius: 0.r,
//                           startDegreeOffset: 0,
//                           sections: showingSections(),
//                           borderData: FlBorderData(show: false),
//                         ),
//                       ),
//                     ),
//                     Gap(16.w),
//                     // Legend Column on the right side
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: dataMap.keys.map((key) {
//                         final color =
//                             colorList[dataMap.keys.toList().indexOf(key)];
//                         return Padding(
//                           padding: EdgeInsets.symmetric(vertical: 4.h),
//                           child: LegendItem(
//                             color: color,
//                             text: key,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<TableRow> _buildCalendarRows(int startWeekday, int daysInMonth) {
//     List<TableRow> rows = [];

//     int day = 1;

//     for (int i = 0; i < 6; i++) {
//       List<Widget> cells = [];
//       for (int j = 0; j < 7; j++) {
//         int cellIndex = i * 7 + j;
//         if (cellIndex >= startWeekday && day <= daysInMonth) {
//           cells.add(
//             Padding(
//               padding: EdgeInsets.all(6.w),
//               child: Center(
//                 child: Text(day.toString(),
//                     style: GoogleFonts.inter(fontSize: 12.sp)),
//               ),
//             ),
//           );
//           day++;
//         } else {
//           cells.add(const SizedBox.shrink());
//         }
//       }
//       rows.add(TableRow(children: cells));
//     }
//     return rows;
//   }

//   List<PieChartSectionData> showingSections() {
//     final total = dataMap.values.reduce((a, b) => a + b);
//     int i = 0;
//     return dataMap.entries.map((entry) {
//       final double percentage = (entry.value / total) * 100;
//       final double radius = 90.r;

//       final section = PieChartSectionData(
//         color: colorList[i],
//         value: entry.value,
//         title: '${percentage.toStringAsFixed(0)}%',
//         radius: radius,
//         titleStyle: GoogleFonts.inter(
//           fontSize: 10.sp,
//           fontWeight: FontWeight.w400,
//           color: Colors.black,
//         ),
//       );
//       i++;
//       return section;
//     }).toList();
//   }

//   String _monthName(int month) {
//     const monthNames = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//     return monthNames[month - 1];
//   }
// }

// class LegendItem extends StatelessWidget {
//   final Color color;
//   final String text;
//   const LegendItem({super.key, required this.color, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 16.w,
//           height: 16.h,
//           color: color,
//         ),
//         Gap(6.w),
//         Text(text,
//             style: GoogleFonts.inter(
//               fontSize: 10.sp,
//               fontWeight: FontWeight.w400,
//               color: Colors.black,
//               letterSpacing: 0.8,
//             )),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int displayedYear = 2025;
  int displayedMonth = 1;

  final List<String> weekdays = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  final Map<String, double> dataMap = {
    "Diary": 22,
    "Meat": 40,
    "Vegetables": 23,
    "Others": 15,
  };

  final List<Color> colorList = const [
    Color(0xFFDDDDDD),
    Color(0xFFCF8989),
    Color(0xFF9ACF89),
    Color(0xFF89B4CF),
  ];

  void _goToPreviousMonth() {
    setState(() {
      if (displayedMonth == 1) {
        displayedMonth = 12;
        displayedYear--;
      } else {
        displayedMonth--;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (displayedMonth == 12) {
        displayedMonth = 1;
        displayedYear++;
      } else {
        displayedMonth++;
      }
    });
  }

  int _daysInMonth(int year, int month) {
    final firstDayThisMonth = DateTime(year, month, 1);
    final firstDayNextMonth =
        (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  int _firstWeekdayOfMonth(int year, int month) {
    int weekday = DateTime(year, month, 1).weekday;
    return weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth(displayedYear, displayedMonth);
    final startWeekday = _firstWeekdayOfMonth(displayedYear, displayedMonth);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: AppColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Image.asset(
                        Assets.icons.arrowBackGrey.path,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    Text(
                      AppStrings.report,
                      style: AppStyle.kohSantepheap16w700C3F3F3F,
                    ),
                    Icon(Icons.more_horiz, color: Colors.grey, size: 24.sp),
                  ],
                ),
              ),
              Gap(12.h),
              // Month and Year with navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 18.sp),
                    onPressed: _goToPreviousMonth,
                  ),
                  Text(
                    "${_monthName(displayedMonth)} $displayedYear",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 18.sp),
                    onPressed: _goToNextMonth,
                  ),
                ],
              ),
              Gap(8.h),
              // Weekday header row
              Table(
                border: TableBorder.all(color: Colors.black54, width: 1.w),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    children: weekdays
                        .map((day) => Padding(
                              padding: EdgeInsets.all(6.w),
                              child: Center(
                                child: Text(
                                  day,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              // Calendar days grid
              Table(
                border: TableBorder.all(color: Colors.black54, width: 1.w),
                children: _buildCalendarRows(startWeekday, daysInMonth),
              ),
              Gap(20.h),
              // Report title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Report of Month ${_monthName(displayedMonth)} $displayedYear",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Gap(10.h),
              // Pie chart and legend side by side
              SizedBox(
                height: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pie Chart
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 5.w,
                          centerSpaceRadius: 0.r,
                          startDegreeOffset: 0,
                          sections: showingSections(),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    Gap(16.w),
                    // Legend Column on the right side
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dataMap.keys.map((key) {
                        final color =
                            colorList[dataMap.keys.toList().indexOf(key)];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: LegendItem(
                            color: color,
                            text: key,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildCalendarRows(int startWeekday, int daysInMonth) {
    List<TableRow> rows = [];

    int day = 1;

    for (int i = 0; i < 6; i++) {
      List<Widget> cells = [];
      for (int j = 0; j < 7; j++) {
        int cellIndex = i * 7 + j;
        if (cellIndex >= startWeekday && day <= daysInMonth) {
          cells.add(
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Center(
                child: Text(day.toString(),
                    style: GoogleFonts.inter(fontSize: 12.sp)),
              ),
            ),
          );
          day++;
        } else {
          cells.add(const SizedBox.shrink());
        }
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }

  List<PieChartSectionData> showingSections() {
    final total = dataMap.values.reduce((a, b) => a + b);
    int i = 0;
    return dataMap.entries.map((entry) {
      final double percentage = (entry.value / total) * 100;
      final double radius = 90.r;

      final section = PieChartSectionData(
        color: colorList[i],
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      );
      i++;
      return section;
    }).toList();
  }

  String _monthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          color: color,
        ),
        Gap(6.w),
        Text(text,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0.8,
            )),
      ],
    );
  }
}
