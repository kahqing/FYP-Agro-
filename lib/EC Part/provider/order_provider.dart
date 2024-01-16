import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/models/order.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  String matric;
  List<Order_> orders = [];
  String orderId = '';

  //late final CartProvider cartProvider;
  OrderProvider({required this.matric}) {
    // Fetch user's order data from Firebase
    loadOrder();
  }

  void updateMatric(String newMatric) {
    matric = newMatric;
    loadOrder(); // Reload order data with the new matric
  }

  //Function to add new order in Firebase
  Future<void> loadOrder() async {
    //Query orders collection
    if (matric != null && matric.isNotEmpty) {
      QuerySnapshot ordersQuery = await FirebaseFirestore.instance
          .collection('orders')
          .where('customerId', isEqualTo: matric)
          .get();
      // Check if any documents were found
      if (ordersQuery.docs.isNotEmpty) {
        orders =
            ordersQuery.docs.map((doc) => Order_.fromSnapshot(doc)).toList();
      }
    } else {
      print('No orders found for customerId: $matric');
    }

    notifyListeners();
  }

  //Function to add new order in Firebase
  Future<String?> addOrder(List<Cart> cartItems, double totalPrice,
      CartProvider cartProvider) async {
    try {
      // Create an order document in the 'orders' collection
      DocumentReference orderRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'customerId': matric,
        'status': 'Prepared',
        'totalPrice': totalPrice,
        'transactionDate': FieldValue.serverTimestamp(),
      });

      //Get the order doc id
      String orderId = orderRef.id;
      print('OrderID: $orderId');

      // Create a subcollection 'orderItems' within the order document
      CollectionReference orderItemsRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .collection('orderItems');

      // Add each cart item as a separate document in the 'orderItems' subcollection
      for (Cart cartItem in cartItems) {
        await orderItemsRef.add({
          'productName': cartItem.productName,
          'productId': cartItem.productId,
          'numOfItems': cartItem.numOfItem,
          'price': cartItem.price,
        });

        //update product status (isSold) is true
        await FirebaseFirestore.instance
            .collection('products')
            .doc(cartItem.productId)
            .update({'isSold': true});

        //delete the cartItems
        await cartProvider.deleteCartItem(cartItem.productId);
      }

      print("order items added successfully");

      notifyListeners();
      return orderId;
    } catch (error) {
      // Handle any errors that might occur during the process
      print('Error adding order: $error');
    }
  }
}
