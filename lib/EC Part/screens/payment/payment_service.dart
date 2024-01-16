import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/models/cartItem.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/prepare_checkout.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/order_confirmation_screen.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  double originalBalance = 0;
  // Function to initiate the payment process
  Future<void> initiatePayment(
      BuildContext context,
      String matric,
      List<SellerGroup> sellerGroups,
      List<CartItem> cartItem,
      OrderProvider orderProvider,
      double totalPrice) async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    try {
      // Check user balance by calling the backend API
      originalBalance = await getCurrentBalance(matric);

      //call endpoint to transfer balance
      bool enoughBalance = await checkAndDeductBalance(matric, totalPrice);

      // Proceed with order processing and escrow creation
      if (enoughBalance) {
        print('widget cartItem: $cartItem');

        //return a map of key is sellerid and value is order id
        Map<String, String> sellerOrderMap =
            await orderProvider.processOrder(sellerGroups);

        if (sellerOrderMap != null && sellerOrderMap.isNotEmpty) {
          print(sellerOrderMap);

          bool escrowCreated =
              await createEscrowRecord(matric, sellerOrderMap, sellerGroups);

          if (escrowCreated) {
            // Close the loading indicator
            Navigator.pop(context);

            // Navigate to the Order Confirmation screen
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderConfirmationScreen(
                  //orderId: orderId,
                  matric: matric,
                ),
              ),
            );
          } else {
            //Rollback on escrow creation failure
            await restoreBalance(matric, originalBalance);
            Navigator.pop(context);
            print('Failed to create escrow record.');
            //handle exception when Failed to create escrow record
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'An unexpected error occurred. Please try making the payment again.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
            return;
          }
        } else {
          //Rollback on order processing failure
          await restoreBalance(matric, originalBalance);
          Navigator.pop(context);
          print('Failed to process order.');
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'An unexpected error occurred. Please try making the payment again.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
          //handle exception when the order processing fails
        }
      } else {
        // Close the loading indicator
        Navigator.pop(context);

        // Display an error dialog for insufficient balance
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Insufficient Account Amount'),
              content: const Text(
                  'Your account balance is not enough to make this payment.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      //Rollback on unexpected error
      await restoreBalance(matric, originalBalance);
      // Close the loading indicator in case of an error
      Navigator.pop(context);

      // Handle other errors as needed
      print('Error during payment initiation: $error');
    }
  }

  Future<double> getCurrentBalance(String matric) async {
    try {
      //fetch document snapshot
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(matric).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        double balance = userData['balance'].toDouble();

        print('user balance is loaded: $balance');
        return balance;
      } else {
        print('User document not found');
      }
    } catch (error) {
      print('Error fetching buyer data: $error');
    }
    return 0;
  }

  //calling backend api to check sufficient balance
  Future<bool> checkAndDeductBalance(String matric, double totalPrice) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiHostname}check-and-deduct-balance'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'matric': matric,
          'totalPrice': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        // The backend returns success, indicating the balance is sufficient
        print('enough balance');
        return true;
      } else if (response.statusCode == 400) {
        print('insufficient balance');
        return false;
      } else {
        //Handle unexpected error
        print('Unexpected error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // handle network errors
      print('Network Error: $e');
      return false;
    }
  }

//api function to create escrow record
  Future<bool> createEscrowRecord(
      String matric,
      Map<String, String> sellerOrderMap,
      List<SellerGroup> sellerGroups) async {
    try {
      //map the seller group data using toMap function
      final List<Map<String, dynamic>> sellerGroupsMap =
          sellerGroups.map((sellerGroup) => sellerGroup.toMap()).toList();

      final response = await http.post(
        Uri.parse('${AppConfig.apiHostname}create-escrow-record'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'buyerId': matric,
          'sellerOrderMap': sellerOrderMap,
          'sellerGroup': sellerGroupsMap
        }),
      );

      if (response.statusCode == 200) {
        // The backend returns success, indicating the escrow record is created
        return true;
      } else {
        // The backend returns an error, indicating failure to create the escrow record
        print(
            'Failed to create escrow record. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error creating escrow record: $error');
      return false;
    }
  }

  Future<void> restoreBalance(String matric, double balance) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiHostname}restore-balance'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'buyerId': matric,
          'originalBalance': balance,
        }),
      );

      if (response.statusCode == 200) {
        // The backend returns success
        print('The balance of buyer is restored.');
      } else {
        // The backend returns an error
        print(
            'Failed to restore buyer balance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error restoring buyer balance: $error');
      rethrow;
    }
  }
}
