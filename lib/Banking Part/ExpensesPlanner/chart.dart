import 'dart:math';

import 'package:agro_plus_app/Database/db.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChartScreen extends StatefulWidget {
  final String id;

  const ChartScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Map<String, Color> categoryColors = {
    "Travel": const Color.fromARGB(255, 239, 54, 54),
    "Food": const Color.fromARGB(255, 255, 185, 46),
    "Shopping": const Color.fromARGB(255, 117, 124, 255),
    "Others": const Color.fromARGB(255, 28, 236, 35),
    "Entertainment": const Color.fromARGB(255, 255, 116, 227),
    "Medical": const Color.fromARGB(255, 246, 255, 113),
    "Bank": const Color.fromARGB(255, 181, 46, 253),
  };
  int touchedIndex = -1;

  Future<Map<String, double>> getTotalExpenses() async {
    Database db = Database();
    Map<String, double> expensesData = {};

    // Replace the categories below with your actual categories
    List<String> categories = [
      "Travel",
      "Food",
      "Shopping",
      "Others",
      "Entertainment",
      "Medical",
      "Bank"
    ];

    for (String category in categories) {
      double totalAmount =
          await db.getTotalExpensesByCategory(widget.id, category);
      expensesData[category] = totalAmount;
    }

    return expensesData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 133, 255, 251),
                Color.fromARGB(255, 242, 255, 170)
              ])),
      child: FutureBuilder<Map<String, double>>(
        future: getTotalExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitFadingCube(
              size: 50,
              color: Color.fromARGB(255, 70, 70, 70),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, double> expensesData = snapshot.data ?? {};
            double totalAmount = expensesData.values.reduce((a, b) => a + b);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Total Spent:\nRM${totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.none,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  )),
                              PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        // Reset touchedIndex when not tapping on a section
                                        setState(() => touchedIndex = -1);
                                        return;
                                      }

                                      // Update touchedIndex
                                      setState(() => touchedIndex =
                                          pieTouchResponse.touchedSection!
                                              .touchedSectionIndex);

                                      // Show details dialog
                                      showDetailsDialog(
                                        context,
                                        expensesData.keys
                                            .toList()[touchedIndex],
                                        expensesData.values
                                            .toList()[touchedIndex],
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 90,
                                  sections: showingSections(expensesData),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 239, 54, 54),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Travel",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 185, 46),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Food",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 246, 255, 113),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Medical",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 28, 236, 35),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Others",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 181, 46, 253),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Bank",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 117, 124, 255),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 1)),
                                ),
                                const Text(
                                  "Shopping",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 116, 227),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 1)),
                              ),
                              const Text(
                                "Entertainment",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      child: Image.asset('assets/images/back.png',
                          width: 60, height: 60)),
                )
                // InkWell(
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                //   child: Container(
                //     child: Image.asset(
                //       'assets/images/back.png',
                //       width: 60, // Adjust the width as needed
                //       height: 60, // Adjust the height as needed
                //     ),
                //   ),
                // ),
              ],
            );
          }
        },
      ),
    );
  }

  void showDetailsDialog(BuildContext context, String category, double value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 248, 227),
          title: Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Total Amount: RM${value.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ), // You can customize this content
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(Map<String, double> expensesData) {
    // Filter out categories with zero values
    expensesData.removeWhere((key, value) => value == 0);

    // Calculate the total amount
    double totalAmount = expensesData.values.reduce((a, b) => a + b);

    return expensesData.entries.map((entry) {
      final isTouched = entry.key.hashCode == touchedIndex;
      final fontSize = isTouched ? 25.0 : 10.0;
      final radius = isTouched ? 80.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      Color categoryColor = categoryColors[entry.key] ?? getRandomColor();
      // Calculate the percentage
      double percentage = (entry.value / totalAmount) * 100;

      // Format the percentage to a string with two decimal places
      String formattedPercentage = percentage.toStringAsFixed(2);

      // Set the percentage as the title
      String title = '';

      // Calculate the position of the title outside the pie chart
      // final double titleRadius = radius + 30.0;

      return PieChartSectionData(
        color: categoryColor,
        value: percentage,
        titlePositionPercentageOffset: 1.5,
        title: title, // You can customize this as needed
        radius: radius,
        // borderSide: const BorderSide(width: 0.5, color: Colors.black),
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          decoration: TextDecoration.none,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
