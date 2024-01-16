import 'package:agro_plus_app/EC%20Part/models/auction.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionHistoryScreen extends StatefulWidget {
  static String routeName = '/auction_history';
  final String matric;

  AuctionHistoryScreen({required this.matric});

  @override
  State<AuctionHistoryScreen> createState() => _AuctionHistoryScreenState();
}

class _AuctionHistoryScreenState extends State<AuctionHistoryScreen> {
  Future<List<Auction?>> fetchAuctionHistory(String matric) async {
    try {
      // Query snapshot to get all auctions where the bidder participated
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collectionGroup('bidders')
              .where('bidderId', isEqualTo: matric)
              .get();

      print('Number of auctions: ${querySnapshot.docs.length}');

      // Convert query snapshot to a list of auction objects
      List<Auction?> auctionHistory = await Future.wait(
        querySnapshot.docs.map((bidderDoc) async {
          DocumentReference<Map<String, dynamic>> auctionRef =
              bidderDoc.reference.parent.parent!; // Get the auction reference

          DocumentSnapshot<Map<String, dynamic>> auctionData =
              await auctionRef.get();

          print('Auction document path: ${auctionData.reference.path}');

          Map<String, dynamic> bidderData = bidderDoc.data();
          return Auction.fromMap(
            {
              ...auctionData.data()!,
              'bidderData': bidderData,
            },
            auctionData.id,
          );
        }),
      );

      return auctionHistory;
    } catch (error) {
      print('Error fetching auction history: $error');
      rethrow;
    }
  }

  Future<String> fetchProductName(String productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

      if (productSnapshot.exists) {
        return productSnapshot.data()?['name'] ?? '';
      } else {
        return '';
      }
    } catch (error) {
      print('Error fetching product details: $error');
      rethrow;
    }
  }

  Map<String, String> auctionProductNames = {};

  Future<void> _fetchAndDisplayAuctions(List<Auction?> auctionHistory) async {
    for (int index = 0; index < auctionHistory.length; index++) {
      Auction? auction = auctionHistory[index];

      if (auction != null) {
        // Fetch the product name based on the product ID if not already fetched
        if (!auctionProductNames.containsKey(auction.auctionId)) {
          String productName = await fetchProductName(auction.productId);

          // Update the auctionProductNames map
          auctionProductNames[auction.auctionId] = productName;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text(
          'Auction History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Auction?>>(
        future: fetchAuctionHistory(widget.matric), //pass matric as bidderId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Auction?> auctionHistory = snapshot.data ?? [];
            // Display a message if auction history is empty
            if (auctionHistory.isEmpty) {
              return const Center(
                child: Text('You have not yet placed a bid.'),
              );
            }

            _handleAuctionData(auctionHistory);

            return Container(
              color: const Color.fromARGB(255, 255, 237, 237),
              child: ListView.separated(
                itemCount: auctionHistory.length,
                itemBuilder: ((context, index) {
                  Auction? auction = auctionHistory[index];

                  if (auction != null) {
                    Map<String, dynamic>? bidderData = auction.bidderData;
                    DateTime bidTime =
                        (bidderData?['timestamp'] as Timestamp).toDate();
                    String status = auction.status;

                    String? productName =
                        auctionProductNames[auction.auctionId];

                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AuctionID: ${auction.auctionId}',
                          ),
                          Text(
                            status,
                            style: TextStyle(
                                color: status == 'End'
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productName != null && productName.isNotEmpty
                              ? Text('Product: $productName')
                              : const Text('Unknown Product'),
                          Text(
                              'Bid Amount: RM ${bidderData?['bidAmount'].toStringAsFixed(2)}'),
                          Text(
                              'Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(bidTime)}'),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Auction data is unavailable'),
                    );
                  }
                }),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            );

            //display auction history
          }
        },
      ),
    );
  }

  // Separate async function to handle asynchronous logic
  Future<void> _handleAuctionData(List<Auction?> auctionHistory) async {
    await _fetchAndDisplayAuctions(auctionHistory);
  }
}
