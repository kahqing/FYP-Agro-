import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_plus_app/EC Part/widgets/product_card.dart';

class BuyNowProductsScreen extends StatelessWidget {
  static String routeName = "/buy_now_listing";

  @override
  Widget build(BuildContext context) {
    Future<List<QueryDocumentSnapshot>> fetchBuyNowProducts() async {
      print("Fetching fixed products.");

      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('isFixedPrice',
              isEqualTo: true) //filter the fixed price product
          .where('isSold', isEqualTo: false) //filter the unsold product
          .get();

      print("Auction product query result: ${productQuery.docs}");

      return productQuery.docs;
    }

    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchBuyNowProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final products = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                elevation: 5,
                title: const Text(
                  'Buy Now Products',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: products != null && products.isNotEmpty
                  ? productListingWidget(products)
                  : const Center(
                      child: Text('No Products available.'),
                    ));
        }
      },
    );
  }

  //widget to return product Listing
  Widget productListingWidget(List<QueryDocumentSnapshot> products) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two products per row
          childAspectRatio: 0.71,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          // final productData = products[index].data() as Map<String, dynamic>;

          // final product = Product.fromMap(productData, productData['id'] ?? '');
          final product = Product.fromSnapshot(products[index]);
          return FixedPriceProductCard(product: product);
        },
      ),
    );
  }
}
