import 'dart:convert';

import 'package:agro_plus_app/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PopularProductStatsBarChart extends StatefulWidget {
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  PopularProductStatsBarChart({required this.sellerId});

  @override
  State<PopularProductStatsBarChart> createState() =>
      _PopularProductStatsBarChartState();
}

class _PopularProductStatsBarChartState
    extends State<PopularProductStatsBarChart> {
  final double barWidth = 10;

  List<Map<String, dynamic>> popularProductList = [];
  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load monthly sales data when the page is first created
    fetchPopularProduct();
  }

  //function to fetch monthly sales data
  Future<void> fetchPopularProduct() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.apiHostname}getTopPopularProducts/sellerId/${widget.sellerId}'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      print('Fetched data: $data'); // Add this print statement

      if (_mounted) {
        setState(() {
          popularProductList = data;
        });
      }
    } else {
      print(
          'Error fetching data. Status code: ${response.statusCode}'); // Add this print statement
    }
  }

  // Calculate the maximum Y value from the data
  double calculateMaxY() {
    double max = 0;
    for (final product in popularProductList) {
      final cartCount = product['cartCount']?.toDouble() ?? 0;
      if (cartCount > max) max = cartCount;
      final clickCount = product['click']?.toDouble() ?? 0;
      if (clickCount > max) max = clickCount;
    }
    // Optionally, you can add some padding to the max value
    return max * 1.5; // Adjust the factor as needed
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: const Color(0xff020227),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, bottom: 5),
            child: Row(
              children: <Widget>[
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.cyanAccent),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cart Count',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Row(
              children: <Widget>[
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.lightGreenAccent),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Click Count',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: BarChart(
                swapAnimationDuration:
                    const Duration(milliseconds: 150), // Optional
                swapAnimationCurve: Curves.linear,
                BarChartData(
                  alignment: BarChartAlignment.start,
                  maxY: calculateMaxY(),
                  groupsSpace: 40,
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
                            color: Colors.greenAccent,
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
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: popularProductList
                      .asMap()
                      .entries
                      .map((entry) => BarChartGroupData(
                            x: entry.key,
                            barsSpace: 5,
                            showingTooltipIndicators: [0, 1],
                            barRods: [
                              BarChartRodData(
                                toY: entry.value['cartCount'].toDouble(),
                                gradient: _cartCountBarsGradient,
                                width: barWidth,
                              ),
                              BarChartRodData(
                                toY: entry.value['click'].toDouble(),
                                gradient: _clickCountBarsGradient,
                                width: barWidth,
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient get _cartCountBarsGradient => const LinearGradient(
        colors: [
          Colors.blueAccent,
          Colors.cyanAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _clickCountBarsGradient => const LinearGradient(
        colors: [
          Colors.limeAccent,
          Colors.lightGreenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.w500,
      fontSize: 14,
      overflow: TextOverflow.ellipsis,
    );
    final product = popularProductList[value.toInt()];
    final name = product['productName'] ?? '';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Container(
        width: 65,
        alignment: Alignment.center,
        child: Text(name, style: style),
      ),
    );
  }
}
