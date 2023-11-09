import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  String matric;
  List<Product> sellerProducts = [];

  ProductProvider({required this.matric}) {
    // Fetch user's product data from Firebase
    loadSellerProducts();
  }

  void updateMatric(String newMatric) {
    matric = newMatric;
    loadSellerProducts(); // Reload product data with the new matric
  }

  // Function to load seller's products from Firestore
  Future<void> loadSellerProducts() async {
    //Query users collection
    if (matric != null && matric.isNotEmpty) {
      QuerySnapshot sellersQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('matric', isEqualTo: matric)
          .get();

      // Check if any documents were found
      if (sellersQuery.docs.isNotEmpty) {
        // Get the first document in the query (there should be only one)
        DocumentSnapshot userDoc = sellersQuery.docs.first;

        // Now, you can create a reference to the user's document
        DocumentReference sellerRef = userDoc.reference;

        //query seller products (sorted using sellerRef)
        QuerySnapshot productsQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('sellerRef', isEqualTo: sellerRef)
            .get();

        sellerProducts = productsQuery.docs.map((doc) {
          Product product = Product.fromSnapshot(doc);
          product.fetchUserData();
          return product;
        }).toList();
      } else {
        print('Seller\'s user document is not found');
      }
    } else {
      print("Seller ID is empty");
    }
    // Notify listeners when the data is loaded.
    notifyListeners();
  }

  // Function to add a product to the seller's list
  Future<bool> addProduct(Map<String, dynamic> formData) async {
    // Implement adding logic here and update sellerProducts
    try {
      final CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      final DocumentReference documentReference = await products.add(formData);
      print('Product added with Id: ${documentReference.id}');
      // Notify listeners when a product is added.
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Function to delete a product from the seller's list
  Future<void> deleteProduct(String productId) async {
    try {
      // Create a reference to the user's product document
      DocumentReference productReference =
          FirebaseFirestore.instance.collection('products').doc(productId);
// Delete the product document
      await productReference.delete();

      //Remove product from sellerProduct list
      sellerProducts.removeWhere((product) => product.id == productId);
      // Notify listeners when a product is deleted.
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
