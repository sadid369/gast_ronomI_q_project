import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../utils/text_style/text_style.dart';
import 'controller/report_controller.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final ReportController reportCtrl = Get.put(ReportController());

  final List<String> weekdays = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  final List<Color> colorList = const [
    Color.fromARGB(121, 239, 38, 38),
    Color(0xFFDDDDDD),
    Color(0xFFCF8989),
    Color(0xFF9ACF89),
    Color(0xFF89B4CF),
  ];

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

  @override
  Widget build(BuildContext context) {
    // Fetch initial data
    reportCtrl.fetchData();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (reportCtrl.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (reportCtrl.errorMessage.isNotEmpty) {
            return Center(child: Text(reportCtrl.errorMessage.value));
          }

          final daysInMonth = _daysInMonth(
              reportCtrl.displayedYear.value, reportCtrl.displayedMonth.value);
          final startWeekday = _firstWeekdayOfMonth(
              reportCtrl.displayedYear.value, reportCtrl.displayedMonth.value);

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        AppStrings.report.tr,
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
                      onPressed: reportCtrl.goToPreviousMonth,
                    ),
                    Text(
                      "${_monthName(reportCtrl.displayedMonth.value)} ${reportCtrl.displayedYear.value}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 18.sp),
                      onPressed: reportCtrl.goToNextMonth,
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
                  children: _buildCalendarRows(
                    startWeekday,
                    daysInMonth,
                  ),
                ),
                Gap(20.h),
                // Report title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${AppStrings.reportofMonth.tr} ${_monthName(reportCtrl.displayedMonth.value)} ${reportCtrl.displayedYear.value}",
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
                            sections:
                                _showingSections(reportCtrl.dataMap, colorList),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      Gap(16.w),
                      // Legend Column on the right side
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reportCtrl.dataMap.keys.map((key) {
                          final color = colorList[
                              reportCtrl.dataMap.keys.toList().indexOf(key) %
                                  colorList.length];
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
          );
        }),
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

  List<PieChartSectionData> _showingSections(
      Map<String, double> dataMap, List<Color> colorList) {
    if (dataMap.isEmpty) {
      return [];
    }
    final allZero = dataMap.values.every((value) => value == 0);
    if (allZero) {
      int i = 0;
      return dataMap.entries.map((entry) {
        final double percentage = 0.0;
        final double radius = 90.r;
        final color = colorList[i % colorList.length];
        final section = PieChartSectionData(
          color: color,
          value: 1,
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
    } else {
      final total = dataMap.values.reduce((a, b) => a + b);
      int i = 0;
      return dataMap.entries.map((entry) {
        final double percentage = (entry.value / total) * 100;
        final double radius = 90.r;
        final color = colorList[i % colorList.length];
        final section = PieChartSectionData(
          color: color,
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
