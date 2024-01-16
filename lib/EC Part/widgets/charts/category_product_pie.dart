import 'dart:convert';
import 'package:agro_plus_app/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsSoldPieCharts extends StatefulWidget {
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  ProductsSoldPieCharts({required this.sellerId});

  @override
  State<ProductsSoldPieCharts> createState() => _ProductsSoldPieChartsState();
}

class _ProductsSoldPieChartsState extends State<ProductsSoldPieCharts> {
  int touchedIndex = -1;

  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  List<Map<String, dynamic>> productCategoryData = [];

  //function to fetch monthly sales data
  Future<void> fetchProductCategoryCount() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.apiHostname}getProductCategory/sellerId/${widget.sellerId}'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      print('Fetched data: $data'); // Add this print statement

      if (_mounted) {
        setState(() {
          productCategoryData = data;
        });
      }
    } else {
      print(
          'Error fetching data. Status code: ${response.statusCode}'); // Add this print statement
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductCategoryCount();
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
          Expanded(
            child: PieChart(PieChartData(
              pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  } else {
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  }
                });
              }),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
              sectionsSpace: 0,
              sections: getSections(),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: getIndicators(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPercentage(int count, int total) {
    double percentage = (count / total) * 100;

    // Check if the percentage has decimal places
    if (percentage % 1 == 0) {
      return '${percentage.toInt()}%';
    } else {
      return '${percentage.toStringAsFixed(2)}%';
    }
  }

  List<PieChartSectionData> getSections() => productCategoryData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final isTouched = index == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 100 : 80;
        final color = data['color'];
        double total =
            productCategoryData.fold(0, (sum, data) => sum + data['count']);

        final value = PieChartSectionData(
          color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
          value: data['count'].toDouble(),
          title: data['count'].toInt().toString(),
          //title: _formatPercentage(data['count'], total.toInt()),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        );

        return MapEntry(index, value);
      })
      .values
      .toList();

  Widget getIndicators(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productCategoryData
          .asMap()
          .map(
            (index, data) => MapEntry(
              index,
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                            int.parse(data['color'].substring(1), radix: 16) +
                                0xFF000000),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${data['category']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            touchedIndex == index ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
