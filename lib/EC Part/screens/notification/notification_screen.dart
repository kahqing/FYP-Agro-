import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = '/notification_screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, dynamic> messageData = {};
  late String winnerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;

      setState(() {
        messageData = json.decode(pushArguments['message']);
        winnerId = messageData['winnerId'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color.fromARGB(255, 197, 0, 0),
          elevation: 5,
          title: const Text("Auction Winner Notification"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              final cartItem = Cart(
                productId: messageData['productId'],
                productName: messageData['productName'],
                price: double.parse(messageData['bidAmount']),
                image: messageData['image'],
              );
              bool added = await cartProvider.addToCart(cartItem);
              // ignore: use_build_context_synchronously
              if (added) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(matric: winnerId),
                  ),
                );
              }
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
              "Proceed to Make Payment",
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
              const Text(
                'Congratulations for winning the auction！',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                'OrderId: ${messageData['auctionId']}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Product: ${messageData['productName']}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Bid Amount: RM ${messageData['bidAmount']}',
                style: const TextStyle(fontSize: 18),
              ),
              Center(
                child: SizedBox(
                    height: 200,
                    width: 250,
                    child: Image.network('${messageData['image']}')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
