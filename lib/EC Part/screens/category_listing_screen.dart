import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  static String routeName = "/category_listing";

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? categoryData = args as Map<String, dynamic>?;

    if (categoryData == null || categoryData['categoryName'] == null) {
      return Text('No category is passing.');
      // Handle the case where the category is not provided.
      // You can show an error message or navigate to a default screen.
    }
    final String category = categoryData['categoryName'];

    Future<List<QueryDocumentSnapshot>> fetchCategoryProducts(
        String category) async {
      print("Fetching products for category: $category");

      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
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
                title: Text(
                  category,
                ),
              ),
              body: products != null && products.isNotEmpty
                  ? product_listing_widget(products)
                  : const Center(
                      child: Text('No Products available.'),
                    ));
        }
      },
    );
  }

  //widget to return product Listing
  Widget product_listing_widget(List<QueryDocumentSnapshot> products) {
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

          final product = Product.fromMap(productData, productData['id'] ?? '');

          return ProductCard(product: product);
        },
      ),
    );
  }
}
