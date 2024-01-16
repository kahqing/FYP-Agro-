import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/widgets/bid_product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionProductsScreen extends StatelessWidget {
  static String routeName = "/auction_listing";

  @override
  Widget build(BuildContext context) {
    //function to fetch auction product that is not reach the endTime
    Future<List<QueryDocumentSnapshot>> fetchAuctionProducts() async {
      print("Fetching auction products.");

      // Fetch products that are not fixed price and not sold
      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('isFixedPrice', isEqualTo: false)
          .where('isSold', isEqualTo: false)
          .get();

      print("Auction product query result: ${productQuery.docs}");

      final auctionProducts = <QueryDocumentSnapshot>[];

      for (final productDoc in productQuery.docs) {
        final productId = productDoc.id;

        // Check if the product's ID exists in the auctions collection
        final auctionsQuery = await FirebaseFirestore.instance
            .collection('auctions')
            .where('productId', isEqualTo: productId)
            .get();

        //check the auction product has not reach the endTime
        if (auctionsQuery.docs.isNotEmpty) {
          print('product auction doc is found');
          final auctionDoc = auctionsQuery.docs.first;
          final endTime = auctionDoc['endTime'] as Timestamp?;
          print('endTime: $endTime');

          if (endTime != null && DateTime.now().isBefore(endTime.toDate())) {
            auctionProducts.add(productDoc);
          }
        }
      }

      return auctionProducts;
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
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                elevation: 5,
                title: const Text(
                  'Auction Products',
                  style: TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.w500,
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
          final productData = products[index].data() as Map<String, dynamic>;

          final productId = products[index].id;

          final product = Product.fromMap(productData, productId);

          return BidProductCard(bidProduct: product);
        },
      ),
    );
  }
}
