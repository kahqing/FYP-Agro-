import 'package:agro_plus_app/EC Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/screens/auction/auction_details_screen.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BidProductCard extends StatelessWidget {
  BidProductCard({
    Key? key,
    this.width = 175, // Increase the width value to your desired size
    this.aspectRatio = 0.9, // Adjust the aspect ratio as needed
    required this.bidProduct,
  }) : super(key: key);

  final double width, aspectRatio;
  final Product bidProduct;
  String apiUrl = AppConfig.apiHostname;

//function to retrieve auction data
  Future<DocumentSnapshot> fetchAuctionData() async {
    return await FirebaseFirestore.instance
        .collection('auctions')
        .where('productId', isEqualTo: bidProduct.id)
        //.where('status', isEqualTo: "Start")
        .get()
        .then((snapshot) => snapshot.docs.first);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAuctionData(),
        builder: (context, auctionSnapshot) {
          if (auctionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (auctionSnapshot.hasError) {
            return Text('Error: ${auctionSnapshot.error}');
          }

          final auctionData = auctionSnapshot.data!.data();
          if (auctionData == null) {
            return const Text('No data found');
          }

          double highestBid = double.parse(
            (auctionData as Map<String, dynamic>)['highestBid'].toString(),
          );
          return Padding(
            padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 10), //padding for starting the row of products
            child: SizedBox(
              width: width,
              child: GestureDetector(
                onTap: () async {
                  final response = await http.post(
                    Uri.parse('${AppConfig.apiHostname}incrementClicks'),
                    body: {
                      'productId': bidProduct.id
                    }, // Pass the product ID or any necessary data
                  );

                  if (response.statusCode == 200) {
                    // Successfully incremented click counter on the backend
                    print('Successfully increment click counter');
                  } else {
                    // Handle error
                    print('Failed to increment click counter on the backend.');
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuctionProductDetailScreen(
                        productId: bidProduct.id,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(
                      10), //padding inside the product card
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            aspectRatio, // Use the specified aspectRatio
                        child: Image.network(
                          bidProduct.image,
                          fit: BoxFit
                              .cover, // Ensure the image covers the container
                        ),
                      ),
                      Text(
                        bidProduct.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "RM${highestBid.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 69, 192, 3),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
