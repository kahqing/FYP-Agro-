import 'dart:convert';
import 'dart:io';
import 'package:agro_plus_app/EC%20Part/screens/order/order_screen_seller.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/product_upload_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/sales_report/pdf_data_api.dart';
import 'package:agro_plus_app/EC%20Part/screens/sales_report/report_generator.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_product_list.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_analysis.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_setting.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signin.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SellerMenuScreen extends StatefulWidget {
  static String routeName = '/seller_menu';
  final String sellerId;

  String apiUrl = AppConfig.apiHostname;

  SellerMenuScreen({required this.sellerId});

  @override
  State<SellerMenuScreen> createState() => _SellerMenuScreenState();
}

class _SellerMenuScreenState extends State<SellerMenuScreen> {
  String sellerName = '';
  int onSale = 0;
  int soldOut = 0;

  @override
  void initState() {
    super.initState();
    loadSellerDetails();
    loadSellerProductStats();
  }

  Future<void> loadSellerDetails() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('seller')
              .doc(widget.sellerId)
              .get();

      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data()!;
        // Check if tax and deliveryFee fields are missing
        if (!data.containsKey('tax') || !data.containsKey('deliveryFee')) {
          // Show a dialog to prompt the seller to fill in tax and deliveryFee
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tax and Delivery Fee Setup'),
                content: const Text(
                    'It seems you haven\'t set up tax and delivery fee. Please go to Seller Settings to fill in the details.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Navigate to SellerSettingScreen
                      Navigator.pushNamed(
                        context,
                        SellerSettingScreen.routeName,
                        arguments: widget.sellerId,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            sellerName = data['sellerName'];
          });
        }
      } else {
        print('Seller document does not exist');
      }
    } catch (e) {
      print('Error loading seller details: $e');
    }
  }

  Future<void> loadSellerProductStats() async {
    try {
      final response = await http.get(Uri.parse(
          '${AppConfig.apiHostname}getProductStats/sellerId/${widget.sellerId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          onSale = data['onSaleCount'];
          soldOut = data['soldOutCount'];
        });
      } else {
        print(
            'Failed to fetch product stats. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading seller details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: null,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(243, 81, 110, 252),
                Color.fromARGB(255, 40, 19, 96),
              ], // Replace with your desired gradient colors
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, right: 20, left: 20),
                    margin: const EdgeInsets.only(
                        top: 25, left: 25, right: 25, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.03),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              //navigate to a page to set delivery fee and tax amount
                              Navigator.pushNamed(
                                  context, SellerSettingScreen.routeName,
                                  arguments: widget.sellerId);
                            },
                            icon: const Icon(
                              Icons.settings,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  SellerSignInScreen.routeName,
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.logout_rounded,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://images.unsplash.com/photo-1531256456869-ce942a665e80?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTI4fHxwcm9maWxlfGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          sellerName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Seller ID: ${widget.sellerId}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                onSale.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Product On Sale",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            width: 0.5,
                            height: 40,
                            color: Colors.black54,
                          ),
                          Column(
                            children: [
                              Text(
                                soldOut.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Product Sold",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Circular border radius
                                  ),
                                ),
                                onPressed: () {
                                  //check whether there is tax and delivery fee field in seller collection in firebase
                                  //if yes, nav to product upload screen
                                  //else, nav to seller setting screen
                                  Navigator.pushNamed(
                                      context, ProductUploadScreen.routeName,
                                      arguments: widget.sellerId);
                                },
                                child: Container(
                                  width: 90,
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_box_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Add Product',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Circular border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context,
                                      SellerProductListScreen.routeName,
                                      arguments: widget.sellerId);
                                },
                                child: Container(
                                  width: 90,
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.list_alt_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Product List',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Circular border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SellerOrderScreen(
                                        sellerId: widget.sellerId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 90,
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Order List',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Circular border radius
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SellerAnalyticsScreen(
                                                sellerId: widget.sellerId,
                                                sellerName: sellerName,
                                              )));
                                },
                                child: Container(
                                  width: 90,
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.query_stats,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Analysis',
                                        style: TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
