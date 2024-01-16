import 'dart:convert';
import 'dart:io';

import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum ProductType { fixedPrice, auction }

class FormHandler {
  bool loading = false;
  bool get isLoading => loading;
  bool isEditMode = false;
  String? auctionId = '';
  String? brand = '';
  String? model = '';

  String? productId = '';
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

  FormHandler(this.productProvider, {required this.isEditMode});

  // Form submission method
  Future<bool> submitForm(BuildContext context, String sellerId) async {
    if (isFormValid(context)) {
      loading = true;

      showDialog(
        context: context,
        barrierDismissible: false,
        // Prevent closing the dialog by tapping outside
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Container(
              color: Colors.grey,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );

      try {
        //await Future.delayed(Duration(seconds: 2));
        //uploading the image to Firebase storage by converting to url

        if (image != null) {
          final url = await uploadImgToFirebaseStorage(image!, context);
          if (url != null) {
            imgURL = url;
          }
        } else {
          if (!isEditMode) {
            loading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to Upload Image.'),
              ),
            );
            Navigator.pop(context);
          }
        }
        //retrieve userDocument
        final userDoc = await FirebaseFirestore.instance
            .collection('user')
            .where('sellerId', isEqualTo: sellerId)
            .get();

        if (userDoc.docs.isNotEmpty) {
          //get the reference to user document
          //final formData = processFormData(sellerId);
          //   final formData = isEditMode
          // ? processEditFormData(sellerId)
          // : processFormData(sellerId);

          if (isEditMode) {
            //if is editing a product details
            final formData = processEditFormData(sellerId);
            print('Product id in form handler: $productId');

            //formData['id'] = productId;
            //update to firebase using product provider
            //final jsonData = jsonEncode(formData);
            bool updatedProduct =
                await productProvider.updateProduct(formData, productId);
            if (!formData['isFixedPrice']) {
              bool updatedAuction = await productProvider.updateAuctionEndTime(
                  auctionId!, formData['endTime']);
              if (updatedProduct && updatedAuction) {
                // Handle successful update
                return true;
              } else {
                // Handle update failure
                return false;
              }
            }

            if (updatedProduct) {
              // Handle successful update
              return true;
            } else {
              // Handle update failure
              return false;
            }
          } else {
            //if is uploading new product
            final formData = processFormData(sellerId);
            //final jsonData = jsonEncode(formData);
            //save to firebase using product provider once getting the url
            bool saved = await productProvider.addProduct(formData);

            if (saved) {
              // Handle successful update
              return true;
            } else {
              // Handle update failure
              return false;
            }
          }
        }
      } catch (error) {
        // Handle errors here
        print("Error: $error");

        // Dismiss the dialog in case of an error
        Navigator.pop(context);

        return false;
      } finally {
        // Ensure that loading is set to false regardless of success or failure
        loading = false;
        Navigator.pop(context);
      }
    }
    return false;
  }

// Validation method
  bool isFormValid(BuildContext context) {
    bool isValid = true;
    print('isEditMode: $isEditMode');

    if (productName.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Name is required'),
        ),
      );
    }
    if (productDescription.isEmpty) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Description is required'),
        ),
      );
    }
    if (productType == ProductType.auction &&
        endTime.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Auction end time should be at least one day before it ends'),
        ),
      );
    }
    if (price <= 0) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price must be greater than 0'),
        ),
      );
    }
    if (category == null) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category is required'),
        ),
      );
    }
    if (!isEditMode && image == null) {
      isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image is required'),
        ),
      );
    }

    return isValid;
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

  // Data processing method: prepare data for storing in firebase
  Map<String, dynamic> processFormData(String sellerId) {
    // Common data
    final formData = {
      'name': productName,
      'description': productDescription,
      'price': price,
      'category': category,
      'image': imgURL,
      'sellerId': sellerId,
      'isSold': false,
      'createdDate': DateTime.now().toIso8601String(),
      'cartCount': 0,
      'clicks': 0,
    };

    // Additional data based on product type
    if (productType == ProductType.auction) {
      formData['isFixedPrice'] = false;
      print('this is an auction product');
      formData['endTime'] = endTime.toIso8601String();
    } else {
      formData['isFixedPrice'] = true;
    }

    // Optional fields
    if (model != null && model!.isNotEmpty) {
      formData['model'] = model;
    }
    if (brand != null && brand!.isNotEmpty) {
      formData['brand'] = brand;
    }

    return formData;
  }

  Map<String, dynamic> processEditFormData(String sellerId) {
    // Common data
    final formData = {
      'name': productName,
      'description': productDescription,
      'price': price,
      'category': category,
      'image': imgURL,
      'sellerId': sellerId,
    };

    // Additional data based on product type
    if (productType == ProductType.auction) {
      formData['isFixedPrice'] = false;
      print('this is an auction product');
      formData['endTime'] = endTime.toIso8601String();
      ;
    } else {
      formData['isFixedPrice'] = true;
    }

    // Optional fields
    if (model != null && model!.isNotEmpty) {
      formData['model'] = model;
    }

    if (brand != null && brand!.isNotEmpty) {
      formData['brand'] = brand;
    }

    return formData;
  }
}
