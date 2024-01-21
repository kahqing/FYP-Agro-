import 'package:agro_plus_app/EC%20Part/models/auction.dart';
import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  String sellerId;
  List<Product> sellerProducts = [];
  String apiUrl = AppConfig.apiHostname;

  ProductProvider({required this.sellerId}) {
    // Fetch user's product data from Firebase
    loadSellerProducts();
  }

  void updateSellerId(String newSellerId) {
    sellerId = newSellerId;
    loadSellerProducts(); // Reload product data with the new matric
  }

  Future<void> loadSellerProducts() async {
    //Query users collection
    if (sellerId != null && sellerId.isNotEmpty) {
      QuerySnapshot sellersQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      // Check if any documents were found
      if (sellersQuery.docs.isNotEmpty) {
        //query seller products (sorted using sellerRef)
        QuerySnapshot productsQuery = await FirebaseFirestore.instance
            .collection('products')
            .where('sellerId', isEqualTo: sellerId)
            .get();

        sellerProducts = productsQuery.docs.map((doc) {
          Product product = Product.fromSnapshot(doc);
          product.fetchSellerData();
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

  // Fetch auction data based on productId
  Future<Auction> fetchAuctionData(String productId) async {
    try {
      final auctionQuery = await FirebaseFirestore.instance
          .collection('auctions')
          .where('productId', isEqualTo: productId)
          .get();

      if (auctionQuery.docs.isNotEmpty) {
        final auctionDoc = auctionQuery.docs.first;
        final auction = Auction.fromMap(
          auctionDoc.data(),
          auctionDoc.id,
        );
        return auction;
      } else {
        // Handle the case where no auction document is found for the given productId
        print('Auction document not found for productId: $productId');
        throw Exception('Auction not found');
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print('Error fetching auction data: $e');
      throw Exception('Error fetching auction data');
    }
  }

  // Function to add a product to the seller's list
  Future<bool> addProduct(Map<String, dynamic> formData) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('${AppConfig.apiHostname}add-product'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the product was added successfully in the backend
        if (responseData['success'] == true) {
          // Notify listeners when a product is added.
          print('Product ID: ${responseData['productId']}');

          if (formData['isFixedPrice'] == false) {
            print('Auction ID: ${responseData['auctionId']}');
          }

          notifyListeners();
          return true;
        } else {
          print(
              'Failed to add product. Server response: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to add product. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Function to update product details using API
  Future<bool> updateProduct(Map<String, dynamic> formData, productId) async {
    try {
      print('Product id in product provider: $productId');
      final http.Response response = await http.put(
        Uri.parse(
            '${AppConfig.apiHostname}update-product/productId/$productId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the product was updated successfully in the backend
        if (responseData['success'] == true) {
          // Notify listeners when a product is updated.
          notifyListeners();
          return true;
        } else {
          print(
              'Failed to update product. Server response: ${responseData['message']}');
          return false;
        }
      } else {
        print('Failed to update product. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Function to update auction end time using API
  Future<bool> updateAuctionEndTime(
      String auctionId, DateTime newEndTime) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(
            '${AppConfig.apiHostname}update-auction-end-time/auctionId/$auctionId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'endTime': newEndTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the auction end time was updated successfully in the backend
        if (responseData['success'] == true) {
          // Notify listeners when the auction end time is updated.
          notifyListeners();
          return true;
        } else {
          print(
              'Failed to update auction end time. Server response: ${responseData['message']}');
          return false;
        }
      } else {
        print(
            'Failed to update auction end time. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating auction end time: $e');
      return false;
    }
  }

  // Function to delete a product from the seller's list
  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '${AppConfig.apiHostname}delete-product/productId/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Add any additional headers as needed
        },
      );

      if (response.statusCode == 200) {
        // Successful deletion
        print('Product deleted successfully.');
      } else {
        // Handle error
        print('Error deleting product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}
