import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class SellerReportGenerator {
  static Future<Document> generateSalesReport(
      List<Map<String, dynamic>> reportData,
      String sellerId,
      String sellerName) async {
    var myTheme = ThemeData.withFont(
      base:
          Font.ttf(await rootBundle.load("assets/fonts/NotoSans_Regular.ttf")),
      bold:
          Font.ttf(await rootBundle.load("assets/fonts/NotoSans_SemiBold.ttf")),
    );
    final pdf = pw.Document(
      theme: myTheme,
    );

    pdf.addPage(MultiPage(
        build: (context) => [
              buildTitle(sellerId, sellerName),
              buildSalesReport(reportData),
              Divider(),
              buildTotal(reportData),
            ]));

    return pdf;
  }

  //title with seller ID and sellerName
  static Widget buildTitle(String sellerId, String sellerName) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Report',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text('Seller Name: $sellerName'),
          Text('Seller ID: $sellerId'),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildSalesReport(List<Map<String, dynamic>> reportData) {
    final headers = [
      'Product Name',
      'Brand',
      'Model',
      'Selling Type',
      'Category',
      'Transaction Date',
      'Price (RM)',
    ];
    final data = reportData.map((item) {
      //final total = item['price'] * item['numOfItem'];
      final sellingType =
          item['productData']['isFixedPrice'] ? 'Fixed-Price' : 'Auction';
      final date = DateTime.parse(item['orderData']['transactionDate']);
      final transactionDate = DateFormat.yMd().format(date);
      //final date = item['transactionDate'];

      return [
        item['productData']['name'],
        item['productData']['brand'] ?? 'N/A',
        item['productData']['model'] ?? 'N/A',
        sellingType,
        item['productData']['category'],
        transactionDate,
        '${item['productData']['price'].toStringAsFixed(2)}',
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(List<Map<String, dynamic>> reportData) {
    final netTotal = reportData.fold<double>(
        0, (sum, item) => sum + item['productData']['price']);

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          'Total Price: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'RM ${netTotal.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ])),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
