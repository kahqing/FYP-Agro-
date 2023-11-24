import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/widgets/bid_product_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  static String routeName = "/category_listing";

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? categoryData = args as Map<String, dynamic>?;

    if (categoryData == null || categoryData['categoryName'] == null) {
      return const Text('No category is passing.');
      // Handle the case where the category is not provided.
      // You can show an error message or navigate to a default screen.
    }
    final String category = categoryData['categoryName'];

    Future<List<QueryDocumentSnapshot>> fetchCategoryProducts(
        String category) async {
      print("Fetching products for category: $category");

      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category) //filter the category product
          .where('isSold', isEqualTo: false) //filter the sold product
          .get();

      print("Category query result: ${productQuery.docs}");

      return productQuery.docs;
    }

    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: fetchCategoryProducts(category),
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
                title: Text(
                  category,
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

  // //Function to retrieve Auction data
  Future<DocumentSnapshot> fetchAuctionData(String productId) async {
    final auctionData = FirebaseFirestore.instance
        .collection('auctions')
        .where('productId', isEqualTo: productId)
        .get()
        .then((snapshot) => snapshot.docs.first);

    return auctionData;
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

          if (product.isFixedPrice) {
            //display regular ProductCard for fixed price product
            return FixedPriceProductCard(product: product);
          } else {
            //display BidProductCard for auction product
            return BidProductCard(bidProduct: product);
          }
        },
      ),
    );
  }
}
