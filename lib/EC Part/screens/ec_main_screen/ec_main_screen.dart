import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/confirm_payment_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/auction_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/bottom_nav_bar.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/component/categories.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/buy_now_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/product_search_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signin.dart';
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
        child: Container(
          color: const Color.fromARGB(255, 255, 237, 237),
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
      ),
    );
  }

  //widget to build header in main screen
  Widget header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          Flexible(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductSearchScreen(),
                  ),
                );
              },
              child: Container(
                height: 50,
                //width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text(
                      'Search ...',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 60,
              height: 60,
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(child: Text('Log Out')),
                          content: const Text(
                            'Are you sure want to log out for Seller Login?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Back'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  SellerSignInScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                'Log Out',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //function to fetch auction product that not reach endTime
  static Future<List<QueryDocumentSnapshot>>
      fetchLimitedAuctionProducts() async {
    //print("Fetching auction products.");

    // Fetch products that are not fixed price and not sold
    final productQuery = await FirebaseFirestore.instance
        .collection('products')
        .where('isFixedPrice', isEqualTo: false)
        .where('isSold', isEqualTo: false)
        .get();

    //print("Auction product query result: ${productQuery.docs}");

    final auctionProducts = <QueryDocumentSnapshot>[];

    for (final productDoc in productQuery.docs) {
      final productId = productDoc.id;

      // Check if the product's ID exists in the auctions collection
      final auctionsQuery = await FirebaseFirestore.instance
          .collection('auctions')
          .where('productId', isEqualTo: productId)
          .get();

      // Check if the auction product has not reached the endTime
      if (auctionsQuery.docs.isNotEmpty) {
        final auctionDoc = auctionsQuery.docs.first;
        final endTime = auctionDoc['endTime'] as Timestamp?;

        if (endTime != null && DateTime.now().isBefore(endTime.toDate())) {
          auctionProducts.add(productDoc);

          // Break the loop when three products are added
          if (auctionProducts.length >= 3) {
            break;
          }
        }
      }
    }

    return auctionProducts;
  }

  //widgets to build Fixed price product list in horizontal view
  Widget auctionProductList(BuildContext context) {
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
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
                future: fetchLimitedAuctionProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final data = snapshot.data;
                  if (data == null || data.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 65),
                      child: Text(
                        "No auction products is available.",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  final products =
                      data.map((doc) => Product.fromSnapshot(doc)).toList();
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
                    .limit(3)
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
