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

    //function to fetch products based on category
    Future<List<QueryDocumentSnapshot>> fetchCategoryProducts(
        String category) async {
      print("Fetching products for category: $category");

      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category) //filter the category product
          .where('isSold', isEqualTo: false) //filter the sold product
          .get();

      print("Category query result: ${productQuery.docs}");

      final filteredProducts = <QueryDocumentSnapshot>[];

      for (final productDoc in productQuery.docs) {
        final isFixedPrice = productDoc['isFixedPrice'] as bool;

        if (!isFixedPrice) {
          // Check if the product is not fixed price, then check auction status
          final productId = productDoc.id;
          final auctionsQuery = await FirebaseFirestore.instance
              .collection('auctions')
              .where('productId', isEqualTo: productId)
              .where('endTime', isGreaterThan: DateTime.now())
              .get();

          if (auctionsQuery.docs.isNotEmpty) {
            // Check if there are active auctions for the product
            filteredProducts.add(productDoc);
          }
        } else {
          // For fixed price products, directly add to the list
          filteredProducts.add(productDoc);
        }
      }

      return filteredProducts;
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
                iconTheme: const IconThemeData(
                  color: Colors.white, //change your color here
                ),
                backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                //elevation: 5,
                title: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    //fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        height: 70, // Adjust the height as needed
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(243, 251, 198, 149),
                                Color.fromARGB(255, 251, 171, 207),
                              ]),
                          //color: Color.fromARGB(255, 255, 193, 216),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          // borderRadius: BorderRadius.only(
                          //     bottomLeft: Radius.circular(10),
                          //     bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //const Text(
                            //   "Price Colour: ",
                            //   style: TextStyle(fontSize: 15),
                            // ),
                            _buildLegendItem(
                              "Auction",
                              const Color.fromARGB(255, 69, 192, 3),
                            ),
                            _buildLegendItem(
                              "Fixed Price",
                              const Color(0xFFFF7643),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: products != null && products.isNotEmpty
                            ? productListingWidget(products)
                            : const Center(
                                child: Text('No Products available.'),
                              ),
                      ),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(children: [
      Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: const Color.fromARGB(255, 84, 90, 46),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        width: 20, // Adjust the width of the colored box
        height: 20, // Adjust the height of the colored box
        margin: const EdgeInsets.only(right: 8),
      ),
      Text(
        label,
        style: const TextStyle(
          //color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    ]);
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
