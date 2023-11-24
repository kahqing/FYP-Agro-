import 'dart:io';

import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum ProductType { fixedPrice, auction }

class FormHandler {
  bool loading = false;
  bool get isLoading => loading;

  String productName = '';
  String productDescription = '';
  ProductType productType = ProductType.fixedPrice; // Default to fixed price
  DateTime endTime = DateTime.now(); //for auction only
  double price = 0.0;
  String? category;
  File? image;

  String? imgURL;

  // Constructor if needed
  final ProductProvider productProvider;
  FormHandler(this.productProvider);

  // Form submission method
  Future<bool> submitForm(BuildContext context, String sellerUserId) async {
    if (isFormValid()) {
      loading = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing data...'),
        ),
      );
      final url = await uploadImgToFirebaseStorage(image!, context);
      if (url != null) {
        imgURL = url;

        //retrieve userDocument
        final userDoc = await FirebaseFirestore.instance
            .collection('user')
            .where('matric', isEqualTo: sellerUserId)
            .get();

        if (userDoc.docs.isNotEmpty) {
          //get the reference to user document
          final formData = processFormData(sellerUserId);
          //save to firebase using product provider once getting the url
          bool saved = await productProvider.addProduct(formData);
          if (saved) {
            return true;
          }
        }
      } else {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Upload Image.'),
          ),
        );
      }
    }
    return false;
  }

  // Validation method
  bool isFormValid() {
    if (productName.isEmpty) {
      print('productName is empty');
    }
    if (productDescription.isEmpty) {
      print('productDescription is empty');
    }
    if (productType == ProductType.auction &&
        endTime.isBefore(DateTime.now())) {
      print('Auction end time should be in the future.');
      return false;
    }
    if (price <= 0) {
      print('price is not greater than 0');
    }
    if (category == null) {
      print('category is null');
    }
    if (image == null) {
      print('image is null');
    }
    if (endTime == null) {
      print('EndTime is null');
    }

    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price > 0 &&
        category != null &&
        image != null;
  }

  Future<String?> uploadImgToFirebaseStorage(
      File imgFile, BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      Reference reference = storage.ref().child('products/$productName.jpg');
      UploadTask uploadTask = reference.putFile(imgFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      imgURL = await taskSnapshot.ref.getDownloadURL();
      return imgURL;
    } catch (e) {
      print('Error occured: $e');
      return null;
    }
  }

  Future<bool> saveToFirebase(
      Map<String, dynamic> formData, BuildContext context) async {
    try {
      final CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      final DocumentReference productDocumentReference =
          await products.add(formData);

      // If it's an auction, save additional details to 'auctions' collection
      if (productType == ProductType.auction) {
        print(productType);
        final CollectionReference auctions =
            FirebaseFirestore.instance.collection('auctions');

        final Map<String, dynamic> auctionData = {
          'productId': productDocumentReference.id,
          'sellerId': formData['sellerUserId'],
          'highestBid': formData['price'], // Set initial highest bid
          'endTime': formData['endTime'],
          'startPrice': formData['price'],
          'status': "Start",
        };

        final DocumentReference auctionDocumentReference =
            await auctions.add(auctionData);
        print('Product added with Id: ${productDocumentReference.id}');
        print('Auction added with Id: ${auctionDocumentReference.id}');
      }

      return true;
    } catch (error) {
      print('Error in adding product: $error');
      return false;
    }
  }

  // Data processing method: prepare data for storing in firebase
  Map<String, dynamic> processFormData(String sellerUserId) {
    // Common data
    final formData = {
      'name': productName,
      'description': productDescription,
      'price': price,
      'category': category,
      'image': imgURL,
      'sellerUserId': sellerUserId,
      'isSold': false,
      'createdDate': DateTime.now(),
    };

    // Additional data based on product type
    if (productType == ProductType.auction) {
      formData['isFixedPrice'] = false;
      print('this is an auction product');
      formData['endTime'] = endTime;
    } else {
      formData['isFixedPrice'] = true;
    }

    return formData;
  }
}
