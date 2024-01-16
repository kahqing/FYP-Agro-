import 'dart:convert';

import 'package:agro_plus_app/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthlySalesBarChart extends StatefulWidget {
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  MonthlySalesBarChart({required this.sellerId});

  @override
  State<MonthlySalesBarChart> createState() => _MonthlySalesBarChartState();
}

class _MonthlySalesBarChartState extends State<MonthlySalesBarChart> {
  final double barWidth = 10;
  String selectedYear = DateTime.now().year.toString();
  List<double> monthlySalesData = List.filled(12, 0.0);
  bool _mounted = true;
  double totalSales = 0.0;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load monthly sales data when the page is first created
    fetchMonthlySales();
  }

  //function to fetch monthly sales data
  Future<void> fetchMonthlySales() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.apiHostname}getMonthlySales/sellerId/${widget.sellerId}/year/$selectedYear'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      print('Fetched data: $data'); // Add this print statement

      if (_mounted) {
        setState(() {
          monthlySalesData = List.filled(12, 0.0);
          for (Map<String, dynamic> monthlyData in data) {
            int month = monthlyData['month'];
            double sales = monthlyData['sales'].toDouble();
            monthlySalesData[month - 1] = sales;
            totalSales += sales;
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
    if (totalSales < 40) {
      return 45;
    } else {
      return totalSales * 1.5;
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
                fetchMonthlySales();
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
            'Total Sales: RM${totalSales.toStringAsFixed(2)}',
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
                groupsSpace: 35,
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
                        rod.toY.toString(),
                        const TextStyle(
                          color: Colors.cyanAccent,
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
                  final toYValue = monthlySalesData[index].toDouble();
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
          Colors.blueAccent,
          Colors.cyanAccent,
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
}
