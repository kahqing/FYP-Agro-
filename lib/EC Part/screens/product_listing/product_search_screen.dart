import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/widgets/bid_product_card.dart';
import 'package:agro_plus_app/EC%20Part/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Product> searchResults = [];
  List<Product> allProducts = [];
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
    // Fetch all products from Firestore
    print("Fetching all products.");

    final productQuery = await FirebaseFirestore.instance
        .collection('products')
        .where('isSold', isEqualTo: false) //filter out the sold product
        .get();

    print("All Product query result: ${productQuery.docs}");

    final filteredProducts = <Product>[];

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
          final auctionProduct = Product.fromSnapshot(productDoc);
          filteredProducts.add(auctionProduct);
        }
      } else {
        // For fixed price products, directly add to the list
        final fixedPriceProduct = Product.fromSnapshot(productDoc);
        filteredProducts.add(fixedPriceProduct);
      }
    }

    setState(() {
      allProducts = filteredProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search products...',
            suffixIcon: isSearchEmpty
                ? const Icon(Icons.search)
                : IconButton(
                    onPressed: () {
                      searchController.clear();
                      _onSearchChanged('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
          ),
        ),
      ),
      body: searchResults.isNotEmpty
          ? productListingWidget(searchResults)
          : isSearchEmpty
              ? const Center(child: Text('Enter keyword to search product.'))
              : const Center(child: Text('No Products available.')),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        //if the search bar is empty
        isSearchEmpty = true;
        searchResults = [];
      } else {
        //when user type something
        isSearchEmpty = false;
        searchResults = allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget productListingWidget(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two products per row
          childAspectRatio: 0.71,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          if (product.isFixedPrice) {
            return FixedPriceProductCard(product: product);
          } else {
            return BidProductCard(bidProduct: product);
          }
        },
      ),
    );
  }
}
