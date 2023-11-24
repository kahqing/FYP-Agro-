import 'package:agro_plus_app/EC%20Part/models/auction.dart';
import 'package:agro_plus_app/matric_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionHistoryScreen extends StatefulWidget {
  static String routeName = '/auction_history';

  @override
  State<AuctionHistoryScreen> createState() => _AuctionHistoryScreenState();
}

class _AuctionHistoryScreenState extends State<AuctionHistoryScreen> {
  late String? matric;

  @override
  void initState() {
    super.initState();

    _loadMatric();
  }

  //load matric value from matric storage
  Future<void> _loadMatric() async {
    try {
      await MatricStorage().loadMatric();
      setState(() {
        //assign matric value
        matric = MatricStorage.matric;
        //print('matric: $matric');
      });
    } catch (error) {
      print('Error loading matric: $error');
    }
  }

  Future<List<Auction?>> fetchAuctionHistory(String matric) async {
    print('matric: $matric');
    try {
      // Query snapshot to get all auctions
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('auctions').get();

      print('Number of auctions: ${querySnapshot.docs.length}');

      // Convert query snapshot to a list of auction objects
      List<Auction?> auctionHistory = await Future.wait(
        querySnapshot.docs.map((auctionDoc) async {
          print('Auction document path: ${auctionDoc.reference.path}');

          QuerySnapshot<Map<String, dynamic>> bidderSnapshot = await auctionDoc
              .reference
              .collection('bidders')
              .where('bidderId', isEqualTo: matric)
              .get();

          print('Number of bidders: ${bidderSnapshot.docs.length}');

          if (bidderSnapshot.docs.isNotEmpty) {
            DocumentSnapshot<Map<String, dynamic>> bidderData =
                bidderSnapshot.docs.first;

            print('Bidder data: ${bidderData.data()}');

            return Auction.fromMap(
              {
                ...auctionDoc.data(),
                'bidderData': bidderData.data(),
              },
              auctionDoc.id,
            );
          } else {
            return null;
          }
        }),
      );

      return auctionHistory;
    } catch (error) {
      print('Error fetching auction history: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (matric == null || matric!.isEmpty) {
      // Matric is not yet initialized, show a loading indicator or return an empty widget
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text('Auction History'),
      ),
      body: FutureBuilder<List<Auction?>>(
        future:
            fetchAuctionHistory(MatricStorage.matric), //pass matric as bidderId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Auction?> auctionHistory = snapshot.data ?? [];

            return ListView.separated(
              itemCount: auctionHistory.length,
              itemBuilder: ((context, index) {
                Auction? auction = auctionHistory[index];

                if (auction != null) {
                  Map<String, dynamic>? bidderData = auction.bidderData;
                  DateTime bidTime =
                      (bidderData?['timestamp'] as Timestamp).toDate();

                  return ListTile(
                    title: Text('AuctionID: ${auction.auctionId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bid Amount: RM ${bidderData?['bidAmount']}'),
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
            );

            //display auction history
          }
        },
      ),
    );
  }
}
