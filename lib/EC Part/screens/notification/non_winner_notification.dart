import 'dart:convert';
import 'package:flutter/material.dart';

class NonWinnerNotificationScreen extends StatefulWidget {
  static String routeName = '/non_winner_notification_screen';
  const NonWinnerNotificationScreen({super.key});

  @override
  State<NonWinnerNotificationScreen> createState() =>
      _NonWinnerNotificationScreenState();
}

class _NonWinnerNotificationScreenState
    extends State<NonWinnerNotificationScreen> {
  Map<String, dynamic> messageData = {};
  late String bidderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;

      setState(() {
        messageData = json.decode(pushArguments['message']);
        bidderId = messageData['recipientId'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color.fromARGB(255, 197, 0, 0),
          elevation: 5,
          title: const Text("Auction Result Notification",
              style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
            },
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
              "Back",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      '${messageData['image']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                'Product: ${messageData['productName']}',
                style: const TextStyle(fontSize: 20),
              ),
              const Text(
                'Sorry, you did not win the auction. Thank you for participating in this auction.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Order ID: ${messageData['auctionId']}',
              //   style: const TextStyle(fontSize: 16),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
