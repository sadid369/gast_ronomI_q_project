import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Add the HTTP package import
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
  int displayedMonth = 6; // You can update this as needed

  final List<String> weekdays = const [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  Map<String, double> dataMap = {}; // Start with an empty map

  final List<Color> colorList = const [
    Color.fromARGB(121, 239, 38, 38),
    Color(0xFFDDDDDD),
    Color(0xFFCF8989),
    Color(0xFF9ACF89),
    Color(0xFF89B4CF),
  ];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch the initial data when the screen loads
  }

  // Function to fetch data from the API
  Future<void> _fetchData() async {
    try {
      final headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTM4MjQ0LCJpYXQiOjE3NDk5NDYyNDQsImp0aSI6IjRjNDIwMGQ1YzY5ODQ5MjI4ZWJiOTg3YTVhYzk5ZGRlIiwidXNlcl9pZCI6MjZ9.NnpeJiYYqUax0QrbHrBciyJtTLj2rTjAxTRHRFwB2BY',
      };

      final response = await http.get(
        Uri.parse(
            'http://10.0.70.145:8001/report/reports/monthly/$displayedYear/$displayedMonth/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Safely convert values to double (even if they are integers)
        final Map<String, double> safeDataMap = {};
        responseData['spending_by_category'].forEach((key, value) {
          // Ensure each value is a double, even if it's an int
          safeDataMap[key] =
              (value is int) ? value.toDouble() : value as double;
        });

        setState(() {
          dataMap = safeDataMap;
        });
      } else {
        // Log status code and body if response is not OK
        print('Failed to load data. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Log error details
      print('Error fetching data: $error');
      throw Exception('Failed to load data');
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      if (displayedMonth == 1) {
        displayedMonth = 12;
        displayedYear--;
      } else {
        displayedMonth--;
      }
    });
    _fetchData(); // Fetch data again when month changes
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
    _fetchData(); // Fetch data again when month changes
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
    // Check if dataMap is empty and show a loading indicator if true
    if (dataMap.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                        final color = colorList[
                            dataMap.keys.toList().indexOf(key) %
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
    // If dataMap is empty, return an empty list or a default section
    if (dataMap.isEmpty) {
      return [];
    }

    // Check if all values are zero
    final allZero = dataMap.values.every((value) => value == 0);

    if (allZero) {
      // Return equal sections with 0% if all values are zero
      int i = 0;
      return dataMap.entries.map((entry) {
        final double percentage =
            0.0; // Set the percentage to 0% for all categories
        final double radius = 90.r;

        // Use modulo to cycle through the colors if the data has more categories than colors available
        final color = colorList[i % colorList.length];

        final section = PieChartSectionData(
          color: color,
          value: 1, // Set value to 1 to ensure sections are visible
          title:
              '${percentage.toStringAsFixed(0)}%', // 0% title for each section
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
      // Normal case where there are non-zero values
      final total = dataMap.values.reduce(
          (a, b) => a + b); // Ensure dataMap is not empty before reducing
      int i = 0;

      return dataMap.entries.map((entry) {
        final double percentage = (entry.value / total) * 100;
        final double radius = 90.r;

        // Use modulo to cycle through the colors if the data has more categories than colors available
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
