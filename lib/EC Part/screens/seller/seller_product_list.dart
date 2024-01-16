import 'package:agro_plus_app/EC%20Part/models/auction.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/product_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agro_plus_app/EC Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC Part/models/product.dart';

class SellerProductListScreen extends StatelessWidget {
  static String routeName = '/seller_product_listing';

  final String sellerId;

  SellerProductListScreen({required this.sellerId});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: true);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 56, 38, 106),
          elevation: 5,
          title: const Text(
            'Seller Products',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            tabAlignment: TabAlignment.fill,
            //isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 17),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(text: 'Fixed Price'),
              Tab(text: 'Auction'),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 205, 212, 246),
          child: Consumer<ProductProvider>(
            builder: (context, value, child) {
              productProvider.updateSellerId(sellerId);
              productProvider.loadSellerProducts();
              List<Product> sellerProducts = productProvider.sellerProducts;

              if (sellerProducts.isEmpty) {
                return const Center(
                  child: Text('No products yet'),
                );
              }

              return TabBarView(
                children: [
                  _buildProductList(sellerProducts, true, context),
                  _buildProductList(sellerProducts, false, context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(
      List<Product> sellerProducts, bool isFixedPrice, BuildContext context) {
    List<Product> filteredProducts = sellerProducts
        .where((product) => product.isFixedPrice == isFixedPrice)
        .toList();

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products yet'),
      );
    }

    // Sort the products based on the isSold property (true first)
    filteredProducts.sort((a, b) {
      if (!a.isSold && b.isSold) {
        return -1;
      } else if (a.isSold && !b.isSold) {
        return 1;
      } else {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        Product product = filteredProducts[index];
        ProductProvider productProvider =
            Provider.of<ProductProvider>(context, listen: true);

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
            color: const Color.fromARGB(255, 237, 230, 230),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey, // Shadow color
                offset: Offset(0, 2), // Horizontal and vertical offset
                blurRadius: 6, // Spread of the shadow
                spreadRadius: 0, // Extend the shadow in all directions
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: 10,
                    height: 100,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text('RM ${product.price.toStringAsFixed(2)}'),
                      Text(product.category),
                      Text(
                        product.isSold ? "Sold" : "On Sale",
                        style: TextStyle(
                            color: product.isSold ? Colors.red : Colors.green),
                      ),
                      // Add more details as needed
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      if (product.isFixedPrice) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                              sellerId: sellerId,
                              product: product,

                              // Pass the product details to pre-fill the form
                            ),
                          ),
                        );
                      } else {
                        //fetch auction data and pass the auction data with product & seller id
                        Auction? auction =
                            await productProvider.fetchAuctionData(product.id);

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                                sellerId: sellerId,
                                product: product,
                                auction: auction
                                // Pass the product and auction details to pre-fill the form
                                ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: const Color.fromARGB(255, 197, 0, 0),
                    onPressed: () {
                      //display a delete confirmation dialog
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Product'),
                              content: const Text(
                                  'Are you sure to delete this product?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    //Close if cancel
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      productProvider.deleteProduct(product.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Product is deleted successfully.'),
                                        ),
                                      );
                                    })
                              ],
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
