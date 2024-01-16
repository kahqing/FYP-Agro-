import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/widgets/bid_product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_plus_app/EC Part/widgets/product_card.dart';

class AuctionProductsScreen extends StatelessWidget {
  static String routeName = "/auction_listing";

  @override
  Widget build(BuildContext context) {
    Future<List<QueryDocumentSnapshot>> fetchAuctionProducts() async {
      print("Fetching auction products.");

      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('isFixedPrice', isEqualTo: false) //filter the category product
          .where('isSold', isEqualTo: false) //filter the sold product
          .get();

      print("Auction product query result: ${productQuery.docs}");

      return productQuery.docs;
    }

    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchAuctionProducts(),
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
                backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                elevation: 5,
                title: const Text('Auction Products'),
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
          final productData = products[index].data() as Map<String, dynamic>;

          final productId = products[index].id;

          final product = Product.fromMap(productData, productId);

          return BidProductCard(bidProduct: product);
        },
      ),
    );
  }
}
