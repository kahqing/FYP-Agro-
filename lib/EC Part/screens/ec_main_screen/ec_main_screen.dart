import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/auction_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/cart/cart_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/bottom_nav_bar.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/categories.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/buy_now_listing.dart';
import 'package:agro_plus_app/EC%20Part/widgets/bid_product_card.dart';
import 'package:agro_plus_app/EC%20Part/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ECMainScreen extends StatelessWidget {
  static String routeName = "/ec_main_screen";
  final String matric;

  const ECMainScreen({required this.matric});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: CustomBottomNavigationBar(
        matric: matric,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              header(context),
              const SizedBox(height: 20),
              Categories(),
              const SizedBox(height: 20),
              buyNowProductList(context),
              auctionProductList(context),
            ],
          ),
        ),
      ),
    );
  }

  //widget to build header in main screen
  Widget header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              width: 280,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(matric: matric),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
                icon: const Icon(Icons.notifications_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //widgets to build Fixed price product list in horizontal view
  Widget auctionProductList(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Auction Products",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  //navigate to product listing
                  Navigator.pushNamed(context, AuctionProductsScreen.routeName);
                },
                child: Text(
                  "See More",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<QuerySnapshot>(
                stream: products
                    .where('isFixedPrice', isEqualTo: false)
                    .where('isSold', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final data = snapshot.data;
                  if (data == null || data.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 65),
                      child: Text(
                        "No auction products is available.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  final products = data.docs
                      .map((doc) => Product.fromSnapshot(doc))
                      .toList();
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: products.map((product) {
                      return BidProductCard(bidProduct: product);
                    }).toList(),
                  );
                }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  //widgets to build auction product list in horizontal view
  Widget buyNowProductList(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Buy Now Products",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  //navigate to product listing
                  Navigator.pushNamed(context, BuyNowProductsScreen.routeName);
                },
                child: Text(
                  "See More",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<QuerySnapshot>(
                stream: products
                    .where('isFixedPrice', isEqualTo: true)
                    .where('isSold', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final data = snapshot.data;
                  if (data == null || data.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 65),
                      child: Text(
                        "No fixed price products is available.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  final products = data.docs
                      .map((doc) => Product.fromSnapshot(doc))
                      .toList();
                  return Row(
                    children: products
                        .map((product) =>
                            FixedPriceProductCard(product: product))
                        .toList(),
                  );
                }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
