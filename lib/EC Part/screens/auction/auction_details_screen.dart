import 'dart:async';

import 'package:agro_plus_app/EC%20Part/models/auction.dart';
import 'package:agro_plus_app/EC%20Part/models/product.dart';
import 'package:agro_plus_app/matric_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionProductDetailScreen extends StatefulWidget {
  static String routeName = '/auction_product_detail';

  final String productId;

  const AuctionProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<AuctionProductDetailScreen> createState() =>
      _AuctionProductDetailScreenState();
}

class _AuctionProductDetailScreenState
    extends State<AuctionProductDetailScreen> {
  late Product auctionProduct;
  late Auction auctionDetails;
  late String matric;
  bool isLoading = true;

  late Duration remainingTime = Duration.zero;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    loadProductDetails();
    _loadMatric();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateRemainingTime();
    });
  }

  @override
  void dispose() {
    //cancel timer when screen is disposed
    timer.cancel();
    super.dispose();
  }

  void updateRemainingTime() {
    DateTime currentTime = DateTime.now();

    if (auctionDetails.endTime.isAfter(currentTime)) {
      remainingTime = auctionDetails.endTime.difference(currentTime);
      setState(() {});
    } else {
      timer.cancel();
      remainingTime = Duration.zero;
      //if the auction ended
    }
  }

  //load matric value
  Future<void> _loadMatric() async {
    try {
      await MatricStorage().loadMatric();
      setState(() {
        //assign matric value
        matric = MatricStorage.matric;
        print('matric: $matric');
      });
    } catch (error) {
      print('Error loading matric: $error');
    }
  }

  //function to load product details
  Future<void> loadProductDetails() async {
    try {
      //fetch product details
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(widget.productId)
              .get();
      if (!productSnapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      //create product object from productSnapshot
      auctionProduct =
          Product.fromMap(productSnapshot.data()!, widget.productId);

      // Now, fetch auction details from the 'auctions' collection
      QuerySnapshot<Map<String, dynamic>> auctionQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('auctions')
              .where('productId', isEqualTo: widget.productId)
              .get();

      //fetch for seller data
      await auctionProduct.fetchSellerData();

      // Check if any documents were found
      if (auctionQuerySnapshot.docs.isNotEmpty) {
        // Assuming there is only one document for a unique productId
        DocumentSnapshot<Map<String, dynamic>> auctionSnapshot =
            auctionQuerySnapshot.docs.first;

        String auctionId = auctionSnapshot.id;

        // Create an AuctionDetails object from the auction data
        auctionDetails = Auction.fromMap(auctionSnapshot.data()!, auctionId);
      }
      // Set loading to false after data is loaded
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Error loading product details:$error');
      setState(() {
        isLoading = false;
      });
    }
  }

  //function to handle user input bid
  void placeBid() {
    //create controller for bid amount text field
    TextEditingController bidController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Place a Bid')),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                const Text("Bid amount must be more than current bid by RM 1"),
                TextField(
                  controller: bidController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Bid Amount',
                  ),
                ),
              ],
            )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  double bidAmount = double.tryParse(bidController.text) ?? 0.0;
                  //handle the bid amount -> update UI and firebase
                  print('Place bid: RM $bidAmount');

                  if (bidAmount >= auctionDetails.highestBid + 1) {
                    updateHighestBid(bidAmount);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Successfully place a bid',
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        backgroundColor: Color.fromARGB(255, 179, 255, 179),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    //show error message / prevent submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Bid amount must be greater than the current bid',
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 237, 237),
                      ),
                    );
                  }
                },
                child: const Text('Place Bid'),
              ),
            ],
          );
        });
  }

  //function to update highest bid
  void updateHighestBid(double bidAmount) async {
    try {
      //Get reference for auction document
      DocumentReference auctionRef = FirebaseFirestore.instance
          .collection('auctions')
          .doc(auctionDetails.auctionId);

      BidderData bidderData = BidderData(
        bidderId: matric,
        bidAmount: bidAmount,
        timestamp: DateTime.now(),
      );

      //update highestBid field
      await auctionRef.update({'highestBid': bidAmount});

      //add bidder data as a subcollection
      CollectionReference bidderCollection = auctionRef.collection('bidders');
      await bidderCollection.add(bidderData.toMap());

      //reload auction details
      await loadProductDetails();
    } catch (error) {
      print('Error placing bid: $error');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color.fromARGB(255, 197, 0, 0),
          elevation: 5,
          title: const Text(
            'Auction Product Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: placeBid,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(350, 40)),
              // Change the size as needed
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // Adjust the radius as needed
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 197, 0, 0)),
              // Change the color to your desired color
            ),
            child: const Text(
              "Place A Bid",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 255, 237, 237),
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Center(
                        child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Shadow color
                            offset: Offset(0, 2), // Changes position of shadow
                            blurRadius: 6, // Changes size of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Match the borderRadius above
                        child: Image.network(
                          auctionProduct.image,
                          width: 200,
                          fit: BoxFit.cover, // Adjust as needed
                        ),
                      ),
                    )),
                    const SizedBox(height: 20),
                    Container(
                      //padding: const EdgeInsets.only(right: 25, left: 25),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              spreadRadius: 0,
                              offset: Offset(0, -2),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 179, 18, 18)
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Remaining Time: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Text(
                                        '${remainingTime.inDays}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    //SizedBox(height: 2,),
                                    const Text('DAYS'),
                                  ],
                                ),
                                //const SizedBox(width: 8),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Text(
                                        '${remainingTime.inHours.remainder(24)}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    //SizedBox(height: 2,),
                                    const Text('HRS'),
                                  ],
                                ),
                                //const SizedBox(width: 8),
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Text(
                                        '${remainingTime.inMinutes.remainder(60)}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    //SizedBox(height: 2,),
                                    const Text('MINS'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auctionProduct.category,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  auctionProduct.name,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //brand and model
                                auctionProduct.brand != null &&
                                        auctionProduct.brand != ''
                                    ? RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Brand: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: auctionProduct.brand,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                //model
                                auctionProduct.model != null &&
                                        auctionProduct.model != ''
                                    ? RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Model: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: auctionProduct.model,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                //description
                                Text(
                                  auctionProduct.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      'Current Bid: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'RM${auctionDetails.highestBid.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text(
                                      'Publish Time: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(auctionProduct.createdDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                //use ternary operator (condition? trueWidget: falseWidget)
                                auctionProduct.sellerData != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Seller: ${auctionProduct.sellerData!['sellerName']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  'Location: ${auctionProduct.sellerData!['address']}',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
