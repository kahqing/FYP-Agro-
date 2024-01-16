import 'dart:convert';

import 'package:agro_plus_app/config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductCategoryStatsRadarChart extends StatefulWidget {
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  ProductCategoryStatsRadarChart({required this.sellerId});

  @override
  State<ProductCategoryStatsRadarChart> createState() =>
      _ProductCategoryStatsRadarChartState();
}

class _ProductCategoryStatsRadarChartState
    extends State<ProductCategoryStatsRadarChart> {
  int selectedDataSetIndex = 0;
  List<Map<String, dynamic>> productCategoryStats = [];

  //function to fetch monthly sales data
  Future<void> fetchProductCategoryStats() async {
    final response = await http.get(Uri.parse(
        '${AppConfig.apiHostname}getCategoryStats/sellerId/${widget.sellerId}'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      print('Fetched data: $data'); // Add this print statement

      setState(() {
        productCategoryStats = data;
      });
    } else {
      print('Error fetching data. Status code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductCategoryStats();
  }

  @override
  Widget build(BuildContext context) {
    if (productCategoryStats.isEmpty) {
      // You can return a loading indicator or an empty container
      return const Center(
          child:
              CircularProgressIndicator()); // Replace this with your preferred loading indicator
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: const Color(0xff020227),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productCategoryStats
                  .asMap()
                  .map((index, data) {
                    final isSelected = index == selectedDataSetIndex;
                    return MapEntry(
                      index,
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDataSetIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          height: 26,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white10
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(46),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInToLinear,
                                padding: EdgeInsets.all(isSelected ? 8 : 6),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                          data['color'].substring(1),
                                          radix: 16) +
                                      0xFF000000),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInToLinear,
                                style: TextStyle(
                                    color: isSelected
                                        ? Color(int.parse(
                                                data['color'].substring(1),
                                                radix: 16) +
                                            0xFF000000)
                                        : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                child: Text(data['category']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.1,
              child: RadarChart(
                RadarChartData(
                  radarTouchData: RadarTouchData(
                    touchCallback: (FlTouchEvent event, response) {
                      if (!event.isInterestedForInteractions) {
                        setState(() {
                          selectedDataSetIndex = -1;
                        });
                        return;
                      }
                      setState(() {
                        selectedDataSetIndex =
                            response?.touchedSpot?.touchedDataSetIndex ?? -1;
                      });
                    },
                  ),
                  dataSets: showingDataSets(),
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.transparent),
                  titlePositionPercentageOffset: 0.15,
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0:
                        return RadarChartTitle(
                            text:
                                'Sold Out [${productCategoryStats[selectedDataSetIndex]['Sold']}]');
                      case 2:
                        return RadarChartTitle(
                            text:
                                'On Sale [${productCategoryStats[selectedDataSetIndex]['onSale']}]');
                      case 1:
                        return RadarChartTitle(
                            text:
                                'Total [${productCategoryStats[selectedDataSetIndex]['totalCount']}]');
                      default:
                        return const RadarChartTitle(text: '');
                    }
                  },
                  tickCount: 5,
                  ticksTextStyle:
                      const TextStyle(color: Colors.transparent, fontSize: 10),
                  tickBorderData: const BorderSide(color: Colors.transparent),
                  gridBorderData:
                      const BorderSide(color: Colors.white, width: 2),
                ),
                swapAnimationDuration: const Duration(milliseconds: 400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return productCategoryStats.asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;
      final dataColor = Color(
          int.parse(rawDataSet['color'].substring(1), radix: 16) + 0xFF000000);

      final isSelected = index == selectedDataSetIndex
          ? true
          : selectedDataSetIndex == -1
              ? true
              : false;

      return RadarDataSet(
        fillColor: isSelected
            ? dataColor.withOpacity(0.5)
            : dataColor.withOpacity(0.05),
        borderColor: isSelected ? dataColor : dataColor.withOpacity(0.5),
        entryRadius: isSelected ? 3 : 2,
        dataEntries: [
          RadarEntry(value: double.parse(rawDataSet['Sold'].toString())),
          RadarEntry(value: double.parse(rawDataSet['totalCount'].toString())),
          RadarEntry(value: double.parse(rawDataSet['onSale'].toString())),
        ],
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }
}
