import 'dart:convert';

import 'package:agro_plus_app/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthlyOrdersBarChart extends StatefulWidget {
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  MonthlyOrdersBarChart({required this.sellerId});

  @override
  State<MonthlyOrdersBarChart> createState() => _MonthlyOrdersBarChartState();
}

class _MonthlyOrdersBarChartState extends State<MonthlyOrdersBarChart> {
  final double barWidth = 10;
  String selectedYear = DateTime.now().year.toString();
  List<int> monthlyOrderData = List.filled(12, 0);
  bool _mounted = true;
  int totalOrder = 0;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load monthly sales data when the page is first created
    fetchMonthlyOrders();
  }

  //function to fetch monthly sales data
  Future<void> fetchMonthlyOrders() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.apiHostname}getMonthlyOrders/sellerId/${widget.sellerId}/year/$selectedYear'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      print('Fetched data: $data'); // Add this print statement

      if (_mounted) {
        setState(() {
          monthlyOrderData = List.filled(12, 0);
          totalOrder = 0; //initialise to 0

          for (Map<String, dynamic> monthlyData in data) {
            int month = monthlyData['month'];
            int orderCount = monthlyData['orderCount'];
            monthlyOrderData[month - 1] = orderCount;
            totalOrder += orderCount;
            print(totalOrder);
          }
        });
      }
    } else {
      print(
          'Error fetching data. Status code: ${response.statusCode}'); // Add this print statement
    }
  }

  //Calculate the maxY based on total orders
  double calculateMaxY() {
    if (totalOrder < 40) {
      return 45;
    } else {
      return totalOrder * 1.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 196, 234, 241),
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: selectedYear,
            onChanged: (String? newValue) {
              setState(() {
                selectedYear = newValue!;
                fetchMonthlyOrders();
              });
            },
            items: <String>[
              '2022',
              '2023',
              '2024',
              '2025'
            ] // Add more years as needed
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Total Orders: $totalOrder',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: const Color(0xff020227),
            child: BarChart(
              swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear,
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: calculateMaxY(),
                groupsSpace: 30,
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  enabled: false, // Enable tooltips
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.toY.toInt().toString(),
                        const TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: getBottomTitles,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: List.generate(12, (index) {
                  final toYValue = monthlyOrderData[index].toDouble();
                  return BarChartGroupData(
                    x: index + 1,
                    barRods: [
                      BarChartRodData(
                        toY: toYValue,
                        gradient: _barsGradient,
                        width: barWidth,
                      ),
                    ],
                    showingTooltipIndicators: toYValue != 0 ? [0] : [],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.orangeAccent,
          Colors.yellowAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    String text = '';
    switch (value.toInt()) {
      case 1:
        text = 'Jan';
        break;
      case 3:
        text = 'Mar';
        break;
      case 5:
        text = 'May';
        break;
      case 7:
        text = 'Jul';
        break;
      case 9:
        text = 'Sep';
        break;
      case 11:
        text = 'Nov';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 254, 255, 255),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 10) {
      text = '10';
    } else if (value == 20) {
      text = '20';
    } else if (value == 30) {
      text = '30';
    } else if (value == 40) {
      text = '40';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
}
