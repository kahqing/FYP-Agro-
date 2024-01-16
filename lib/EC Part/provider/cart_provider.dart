import 'dart:convert';
import 'package:agro_plus_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:agro_plus_app/EC%20Part/models/cartItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AddToCartResult {
  success,
  alreadyInCart,
  serverError,
}

class CartProvider with ChangeNotifier {
  String matric;
  List<CartItem> cartItemList = [];
  String apiUrl = AppConfig.apiHostname;

  CartProvider({required this.matric}) {
    //fetch user's cart data from firebase
    loadCartData();
  }

  void updateMatric(String newMatric) {
    matric = newMatric;
    loadCartData();
  }

  Future<void> loadCartData() async {
    try {
      // Create a reference to the user's cart document
      DocumentReference cartDocument =
          FirebaseFirestore.instance.collection('carts').doc(matric);

      // Get the cart items subcollection
      QuerySnapshot cartItemsSnapshot =
          await cartDocument.collection('cartItems').get();

      // Clear the cartList
      cartItemList.clear();

      for (QueryDocumentSnapshot itemDoc in cartItemsSnapshot.docs) {
        final data = itemDoc.data() as Map<String, dynamic>;
        final productId = data['productId'] ?? '';

        // Fetch the isSold value from the products collection
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          final productData = productSnapshot.data() as Map<String, dynamic>;
          final isSold = productData['isSold'];

          if (!isSold) {
            // If the product is not sold, add it to cartItemList
            cartItemList.add(
              CartItem(
                productId: productId,
                productName: data['productName'] ?? '',
                sellerId: data['sellerId'] ?? '',
                price: data['price'].toDouble() ?? 0.0,
                image: data['image'] ?? '',
                numOfItem: data['numOfItem'] ?? 0.0,
              ),
            );
          } else {
            // If the product is sold, invoke deleteCartItem directly
            await deleteCartItem(productId);
          }
        }
      }

      notifyListeners();
    } catch (error) {
      print('Error loading cart data: $error');
    }
  }

  Future<AddToCartResult> addToCart(CartItem itemData) async {
    try {
      final url = Uri.parse('${AppConfig.apiHostname}addToCart');

      final response = await http.post(
        url,
        body: json.encode({
          'matric': matric,
          'productId': itemData.productId,
          'productName': itemData.productName,
          'sellerId': itemData.sellerId,
          'price': itemData.price,
          'image': itemData.image,
          'numOfItem': itemData.numOfItem,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          notifyListeners();
          print("Item is added to cart successfully");
          return AddToCartResult.success;
        } else {
          // Handle server error
          return AddToCartResult.serverError;
        }
      } else if (response.statusCode == 409) {
        print("Item already exists in the cart");
        return AddToCartResult.alreadyInCart;
      } else {
        // Handle other HTTP response codes
        return AddToCartResult.serverError;
      }
    } catch (error) {
      print('Error adding to cart: $error');
      return AddToCartResult.serverError;
    }
  }

  // Delete an item from the user's cart in Firestore
  Future<void> deleteCartItem(String productId) async {
    try {
      final url = Uri.parse(
          '${AppConfig.apiHostname}deleteCartItem/$matric/$productId');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Check the response from the server, adjust as needed
        if (responseData['success'] == true) {
          loadCartData();
          print('cart item with $productId is deleted');
          notifyListeners();
        } else {
          // Handle server error
          print('Server error: ${responseData['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting cart item: $error');
    }
  }
}
