import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/product_upload_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerDashboard extends StatefulWidget {
  static String routeName = '/seller_dashboard';
  final String sellerUserId;
  SellerDashboard({required this.sellerUserId});

  @override
  _SellerDashboardState createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final ProductProvider productProvider = ProductProvider();
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    productProvider.loadSellerProducts(widget.sellerUserId);
    productList = productProvider.sellerProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
      ),
      body: sellerItem(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Show the product upload screen and wait for it to complete
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductUploadScreen(sellerUserId: widget.sellerUserId),
            ),
          );

          // Product added successfully
          if (result == true) {
            //re-fetch and update the list of products
            Provider.of<ProductProvider>(context, listen: false)
                .loadSellerProducts(widget.sellerUserId);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget sellerItem(BuildContext context) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      productProvider.loadSellerProducts(widget.sellerUserId);
      productList = productProvider.sellerProducts;
      // Use productProvider to access sellerProducts
      if (productProvider.sellerProducts.isEmpty) {
        return const Center(
          child: Text('No Products is on sale'),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: seller_item_card(
                          product: productList[index], context: context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget seller_item_card(
      {required Product product, required BuildContext context}) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            height: 120,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.network(product.image),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                maxLines: 2,
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Color.fromARGB(255, 197, 0, 0), // Use the trash can icon
            onPressed: () {
              //display a delete confirmation dialog
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Delete Product'),
                      content:
                          const Text('Are you sure to delete this product?'),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Product is deleted successfully.'),
                                ),
                              );
                            })
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
