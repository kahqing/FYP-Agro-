import 'dart:io';

import 'package:agro_plus_app/EC%20Part/screens/sales_report/pdf_data_api.dart';
import 'package:agro_plus_app/EC%20Part/screens/sales_report/report_generator.dart';
import 'package:agro_plus_app/EC%20Part/widgets/charts/popular_product_bar_chart.dart';
import 'package:agro_plus_app/EC%20Part/widgets/charts/radar_chart.dart';
import 'package:agro_plus_app/EC%20Part/widgets/charts/total_order_bar_chart.dart';
import 'package:agro_plus_app/EC%20Part/widgets/charts/total_sales_bar_chart.dart';
import 'package:agro_plus_app/EC%20Part/widgets/charts/category_product_pie.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SellerAnalyticsScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  const SellerAnalyticsScreen(
      {required this.sellerId, required this.sellerName});

  @override
  State<SellerAnalyticsScreen> createState() => _SellerAnalyticsScreenState();
}

class _SellerAnalyticsScreenState extends State<SellerAnalyticsScreen> {
  var analytics = [
    'Total Sales',
    'Total Orders',
    'Category Products',
    'Product Summary',
    'Top Popular Products',
  ];

  int selectedIdx = -1; // Initially, no item is selected

  Widget getSelectedWidget() {
    switch (selectedIdx) {
      case 0:
        // Return the widget for 'Total Sales'
        return MonthlySalesBarChart(
          sellerId: widget.sellerId,
        );
      case 1:
        // Return the widget for 'Total Orders'
        return MonthlyOrdersBarChart(
          sellerId: widget.sellerId,
        );
      case 2:
        // Return the widget for 'Popular Products Sold'
        return ProductsSoldPieCharts(
          sellerId: widget.sellerId,
        );
      case 3:
        // Return the widget for 'Popular Products Click'
        return ProductCategoryStatsRadarChart(
          sellerId: widget.sellerId,
        );

      case 4:
        // Return the widget for 'Cart Abandonment'
        return PopularProductStatsBarChart(
          sellerId: widget.sellerId,
        );
      default:
        return const Center(
          child: Text(
            'Click to view the sales performance',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 40, 19, 96),
          actions: [
            IconButton(
              onPressed: () async {
                print('Download Sales Report');

                //ask whether want to generate report
                bool downloadConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Download Sales and Product Report'),
                      content: const Text(
                          'Do you want to download the sales and product report in PDF?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (downloadConfirmed) {
                  // Fetch sales and product data using the sellerId

                  final List<Map<String, dynamic>> productData =
                      await fetchCombinedData(widget.sellerId);
                  //generate and save the pdf using function at pdf generator
                  final pdf = await SellerReportGenerator.generateSalesReport(
                      productData, widget.sellerId, widget.sellerName);
                  final bytes = await pdf.save();

                  final externalDir = await getExternalStorageDirectory();
                  ;
                  print(externalDir?.path);
                  final file = File('${externalDir?.path}/SalesReport.pdf');
                  print(file.path);
                  await file.writeAsBytes(bytes);

                  try {
                    await OpenFile.open(file.path);
                  } on Exception catch (e) {
                    print(e);
                  }
                }
              },
              icon: const Icon(
                Icons.download,
                size: 30,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 40, 19, 96),
                Color.fromARGB(243, 81, 110, 252),
              ], // Replace with your desired gradient colors
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Seller Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(243, 209, 215, 248),
                ),
              ),
              const Text(
                'Provide Insights to make informed decision',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(243, 209, 215, 248),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 40,
                child: ListView.builder(
                    itemCount: analytics.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIdx = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: index == selectedIdx
                                  ? Colors.transparent
                                  : const Color.fromARGB(197, 56, 43, 90),
                              border: Border.all(
                                color: index == selectedIdx
                                    ? Colors.white
                                    : const Color.fromARGB(255, 174, 140, 241),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              analytics[index],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: index == selectedIdx
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          255, 174, 140, 241),
                                  fontWeight: index == selectedIdx
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: getSelectedWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
