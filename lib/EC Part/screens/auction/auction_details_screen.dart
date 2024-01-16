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

  @override
  void initState() {
    super.initState();
    loadProductDetails();
    _loadMatric();
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
      await auctionProduct.fetchUserData();

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
            title: const Text('Place a Bid'),
            content: TextField(
              controller: bidController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Enter Bid Amount'),
            ),
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
                        backgroundColor: Color.fromARGB(255, 245, 179, 255),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text('Auction Product Details'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Center(
                      child: Container(
                    //width: 200,
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
                  const SizedBox(height: 10),
                  Text(
                    auctionProduct.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  //description
                  Text(
                    auctionProduct.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: Text('Category: ${auctionProduct.category}'),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Created Time: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(auctionProduct.createdDate),
                        // style: const TextStyle(
                        //   fontSize: 22,

                        // ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'End Time: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        DateFormat('yyyy-MM-dd hh:mm a')
                            .format(auctionDetails.endTime),
                        style: const TextStyle(
                          color: Color(0xFFFF7643),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  //use ternary operator (condition? trueWidget: falseWidget)
                  auctionProduct.sellerData != null
                      ? Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seller: ${auctionProduct.sellerData!['username']}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Location: ${auctionProduct.sellerData!['address']}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
