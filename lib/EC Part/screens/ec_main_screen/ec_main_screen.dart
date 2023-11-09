import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/screens/cart/cart_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/bottom_nav_bar.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/categories.dart';
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
              buy_now_prod_list(),
              auction_prod_list(),
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
            child: Container(
              height: 50,
              width: 280,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search ...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
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
            child: Container(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
                icon: Icon(Icons.notifications_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //widgets to build Fixed price product list in horizontal view
  Widget auction_prod_list() {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                },
                child: Text(
                  "See More",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  products.where('isFixedPrice', isEqualTo: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final data = snapshot.data;
                if (data == null || data.docs.isEmpty) {
                  return const Text('No auction products available.');
                }

                final products =
                    data.docs.map((doc) => Product.fromSnapshot(doc)).toList();
                return Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: products
                      .map((product) => ProductCard(product: product))
                      .toList(),
                );
              }),
        ),
      ],
    );
  }

  //widgets to build auction product list in horizontal view
  Widget buy_now_prod_list() {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                },
                child: Text(
                  "See More",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  products.where('isFixedPrice', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final data = snapshot.data;
                if (data == null || data.docs.isEmpty) {
                  return Text('No fixed price products available.');
                }

                final products =
                    data.docs.map((doc) => Product.fromSnapshot(doc)).toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: products
                      .map((product) => ProductCard(product: product))
                      .toList(),
                );
              }),
        ),
      ],
    );
  }
}
