import 'dart:convert';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SellerSettingScreen extends StatefulWidget {
  static String routeName = '/setting';
  final String sellerId;
  String apiUrl = AppConfig.apiHostname;

  SellerSettingScreen({required this.sellerId});

  @override
  State<SellerSettingScreen> createState() => _SellerSettingScreenState();
}

class _SellerSettingScreenState extends State<SellerSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late double tax;
  late double deliveryFee;
  bool isInitialValuesLoaded = false;

  Future<bool> saveTaxAndDelivery(double tax, double deliveryFee) async {
    try {
      // Make API call to store tax and delivery fee
      final response = await http.post(
        Uri.parse(
            '${AppConfig.apiHostname}saveTaxAndDelivery/${widget.sellerId}'),
        body: jsonEncode({
          'tax': tax,
          'deliveryFee': deliveryFee,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Tax and delivery fee saved successfully');
        return true;
      } else {
        // Handle API error
        print('Failed to save tax and delivery fee: ${response.reasonPhrase}');
        return false;
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      return false;
    }
  }

  Future<void> getInitialValues() async {
    try {
      // Retrieve initial values directly from Firestore
      final DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .doc(widget.sellerId)
          .get();

      if (sellerSnapshot.exists) {
        final data = sellerSnapshot.data() as Map<String, dynamic>;
        setState(() {
          // Update state with initial values if available
          tax = data['tax']?.toDouble() ?? 0.0;
          deliveryFee = data['deliveryFee']?.toDouble() ?? 0.0;
          isInitialValuesLoaded = true;
        });
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial values when the widget is initialized
    getInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: (const IconThemeData(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 19, 96),
        elevation: 0,
        title: const Text("Tax and Delivery Fee Setting",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: isInitialValuesLoaded
            ? Center(
                child: Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 500,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black, // Shadow color
                            // Horizontal and vertical offset
                            offset: Offset(0, 2),

                            blurRadius: 6, // Spread of the shadow
                            // Extend the shadow in all directions
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff020227),
                      ),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, bottom: 15),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Enter 0 if dun have tax.',
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                labelText: 'Tax (%)',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter tax';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                tax = double.parse(value!);
                              },
                              initialValue: tax.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, bottom: 15),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                hintText: 'Enter 0 if dun have delivery fee.',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                labelText: 'Delivery Fee (RM)',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter delivery fee';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                deliveryFee = double.parse(value!);
                              },
                              initialValue: deliveryFee.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize: const Size.fromWidth(280),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                //call backend api server to save tax and delivery fee
                                final success =
                                    await saveTaxAndDelivery(tax, deliveryFee);
                                final snackBar = SnackBar(
                                  content: Text(
                                    success
                                        ? 'Tax and delivery fee saved successfully'
                                        : 'Failed to save tax and delivery fee',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: success
                                      ? const Color.fromARGB(255, 102, 235, 122)
                                      : const Color.fromARGB(
                                          255, 245, 179, 255),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Notes: Please fill in the tax and delivery fee before uploading product. You can enter 0 if dun require tax or delivery fee.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    )),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
