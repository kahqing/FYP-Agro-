import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/models/order.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/prepare_checkout.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends ChangeNotifier {
  String matric;
  List<Order_> orders = [];
  String orderId = '';
  late CartProvider cartProvider;
  String apiUrl = AppConfig.apiHostname;

  //late final CartProvider cartProvider;
  OrderProvider({required this.matric}) {
    // Fetch user's order data from Firebase
    loadBuyerOrders(matric);
    cartProvider = CartProvider(matric: matric);
  }

  void updateMatric(String newMatric) {
    matric = newMatric;
    loadBuyerOrders(matric); // Reload order data with the new matric
  }

  //function to load buyer orders
  Future<void> loadBuyerOrders(String matric) async {
    // Query orders collection
    if (matric != null && matric.isNotEmpty) {
      QuerySnapshot ordersQuery = await FirebaseFirestore.instance
          .collection('orders')
          .where('buyerId', isEqualTo: matric)
          .get();

      // Check if any documents were found
      if (ordersQuery.docs.isNotEmpty) {
        // Clear the existing data
        orders.clear();

        for (QueryDocumentSnapshot orderDoc in ordersQuery.docs) {
          Order_ order = Order_.fromSnapshot(orderDoc);
          // Retrieve seller name
          QuerySnapshot sellerQuery = await FirebaseFirestore.instance
              .collection('seller')
              .where('sellerId', isEqualTo: order.sellerId)
              .get();

          if (sellerQuery.docs.isNotEmpty) {
            // Assuming there is only one matching document
            DocumentSnapshot sellerDoc = sellerQuery.docs.first;
            order.sellerName = sellerDoc['sellerName'];
          } else {
            // Handle the case where no matching seller is found
            order.sellerName = 'Unknown Seller';
          }

          // Retrieve order items for each order
          QuerySnapshot orderItemsQuery =
              await orderDoc.reference.collection('orderItems').get();

          if (orderItemsQuery.docs.isNotEmpty) {
            order.orderItems = [];
            for (QueryDocumentSnapshot itemDoc in orderItemsQuery.docs) {
              OrderItem orderItem = OrderItem.fromSnapshot(itemDoc);

              // Retrieve product image URL
              DocumentSnapshot productDoc = await FirebaseFirestore.instance
                  .collection('products')
                  .doc(orderItem.productId)
                  .get();
              orderItem.image = productDoc['image'];

              order.orderItems.add(orderItem);
              orders.add(order);
              //print(order.orderItems);
            }
          }
        }
      } else {
        print('No orders found for customerId: $matric');
      }

      notifyListeners();
    }
  }

  //function to load seller orders
  Future<void> loadSellerOrders(String sellerId) async {
    try {
      // Query orders collection
      QuerySnapshot sellerOrdersQuery = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      // Check if any documents were found
      if (sellerOrdersQuery.docs.isNotEmpty) {
        // Clear the existing data
        orders.clear();

        for (QueryDocumentSnapshot orderDoc in sellerOrdersQuery.docs) {
          Order_ order = Order_.fromSnapshot(orderDoc);
          // Retrieve seller name

          // Retrieve order items for each order
          QuerySnapshot orderItemsQuery =
              await orderDoc.reference.collection('orderItems').get();

          if (orderItemsQuery.docs.isNotEmpty) {
            order.orderItems = [];
            for (QueryDocumentSnapshot itemDoc in orderItemsQuery.docs) {
              OrderItem orderItem = OrderItem.fromSnapshot(itemDoc);

              // Retrieve product image URL
              DocumentSnapshot productDoc = await FirebaseFirestore.instance
                  .collection('products')
                  .doc(orderItem.productId)
                  .get();
              orderItem.image = productDoc['image'];

              order.orderItems.add(orderItem);
              orders.add(order);
              //print(order.orderItems);
            }
          }
        }
      } else {
        print('No orders found for sellerId: $sellerId');
      }

      notifyListeners();
    } catch (error) {
      print('Error loading seller orders: $error');
    }
  }

  //function to process order - adding order record
  // Future<String?> processOrder(
  //     List<CartItem> cartItems, double totalPrice) async {
  //   try {
  //     print('CartItems: ');
  //     cartItems.forEach((item) {
  //       print(item.toMap());
  //     });

  //     final response = await http.post(
  //       Uri.parse('${AppConfig.apiHostname}process-order'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'cartItems': cartItems.map((item) => item.toMap()).toList(),
  //         'buyerId': matric,
  //         'totalPrice': totalPrice,
  //       }),
  //     );

  //     // Display encoded JSON in the console
  //     // print('Encoded JSON:');
  //     // print(jsonEncode(<String, dynamic>{
  //     //   'cartItems': cartItems.map((item) => item.toMap()).toList(),
  //     //   'buyerId': matric,
  //     //   'totalPrice': totalPrice,
  //     // }));

  //     if (response.statusCode == 200) {
  //       // Extract information from the response, e.g., orderId
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       final String? orderId = data['orderId'];
  //       print('Backend response - order placed with id: $data');

  //       return orderId;
  //     } else {
  //       // Handle error responses
  //       print('Failed to process order. Status code: ${response.statusCode}');
  //       // ...
  //     }
  //   } catch (error) {
  //     // Handle network or other errors
  //     print('Error processing order: $error');
  //   }
  //   return null;
  // }

  Future<Map<String, String>> processOrder(
      List<SellerGroup> sellerGroups, String address) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiHostname}process-order'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'sellerGroups': sellerGroups
              .map((sellerGroup) => {
                    'sellerId': sellerGroup.sellerId,
                    'cartItems': sellerGroup.cartItems
                        .map((item) => item.toMap())
                        .toList(),
                    'total': sellerGroup.total,
                  })
              .toList(),
          'buyerId': matric,
          'deliveryAddress': address,
          //'totalPrice': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        // Extract information from the response, e.g., orderIds
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, String> sellerOrderMap =
            Map<String, String>.from(data['sellerOrderMap']);

        print('Orders are made. $sellerOrderMap');

        return sellerOrderMap;
      } else {
        // Handle error responses
        print('Failed to process order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error processing order: $error');
    }
    return {};
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    print("orderId: $orderId Newstatus: $newStatus");
    try {
      // Update the order item status using the backend API
      final response = await http.put(
        Uri.parse('${AppConfig.apiHostname}update-order-status'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'orderId': orderId,
          'newStatus': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated the status on the backend
        print('Order item status updated on the backend');

        //   // If the new status is "Completed", trigger the transfer of amount from escrow
        // if (newStatus == "Completed") {
        //   await http.post(
        //     Uri.parse('${AppConfig.apiHostname}transfer-amount-from-escrow'),
        //     headers: <String, String>{
        //       'Content-Type': 'application/json',
        //     },
        //     body: jsonEncode(<String, dynamic>{
        //       'orderId': orderId,
        //       'sellerId': sellerId,
        //       'productId': productId,
        //     }),
        //   );
        //   print('Amount transferred from escrow.');
        // }
      } else {
        // Handle error responses from the backend
        print(
            'Failed to update order item status on the backend. Status code: ${response.statusCode}');
      }

      notifyListeners();
    } catch (error) {
      print('Error updating order item status: $error');
    }
  }
}
