import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  String matric;
  List<Cart> cartList = [];

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
      //create a referenve to user's cart document
      DocumentReference cartDocument =
          FirebaseFirestore.instance.collection('carts').doc(matric);

      //Get the cart items subcollection
      QuerySnapshot cartItemsSnapshot =
          await cartDocument.collection('cartItems').get();

      //Map the cart items to Cart objects
      cartList = cartItemsSnapshot.docs.map((itemDoc) {
        final data = itemDoc.data() as Map<String, dynamic>;
        return Cart(
          productId: data['productId'] ?? '',
          productName: data['productName'] ?? '',
          price: data['price'] ?? 0.0,
          image: data['image'] ?? '',
          numOfItem: data['numOfItem'] ?? 0.0,
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading cart data: $error');
    }
  }

  Future<void> addToCart(Cart itemData) async {
    //Create reference to user cart document
    DocumentReference cartDocument =
        FirebaseFirestore.instance.collection('carts').doc(matric);

    // add item to cart item subcollection
    await cartDocument.collection('cartItems').add({
      'productId': itemData.productId,
      'productName': itemData.productName,
      'price': itemData.price,
      'image': itemData.image,
      'numOfItem': itemData.numOfItem,
    });
    notifyListeners();
  }

  // Delete an item from the user's cart in Firestore
  Future<void> deleteCartItem(String itemId) async {
    // Create a reference to the user's cart document
    DocumentReference cartDocument =
        FirebaseFirestore.instance.collection('carts').doc(matric);

    // Delete the item from the cart items subcollection
    QuerySnapshot querySnapshot = await cartDocument
        .collection('cartItems')
        .where('productId', isEqualTo: itemId)
        .get();
    // final querySnapshot = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('cart1')
    //     .where('productId', isEqualTo: itemId)
    //     .get();

    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      await document.reference.delete();
      cartList.removeWhere((item) => item.productId == itemId);
      print('cart item with $itemId is deleted');
      notifyListeners();
    }
  }
}
