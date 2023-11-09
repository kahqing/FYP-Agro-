import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/order_confirmation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  static String routeName = '/checkout';

  final String userId;
  final List<Cart> cartItem;
  final double totalPrice;

  const CheckoutScreen({
    required this.userId,
    required this.cartItem,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderProvider orderProvider = OrderProvider();

  String userAddress = '';
  double accAmount = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          final userData = snapshot.data;
          if (userData != null) {
            userAddress = userData.get('address');
            accAmount = userData.get('amount').toDouble();
          }
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 197, 0, 0),
            elevation: 5,
            title: const Text(
              'Checkout',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                ),
                child: Text(
                  'Delivery address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              user_details(),
              const SizedBox(
                height: 10,
              ),
              order_summary(),
            ],
          ),
          bottomNavigationBar: bottom_nav_bar(context),
        );
      },
    );
  }

  //user address
  Widget user_details() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Shadow color
            offset: Offset(0, 2), // Horizontal and vertical offset
            blurRadius: 6, // Spread of the shadow
            spreadRadius: 0, // Extend the shadow in all directions
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            userAddress,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }

  //order summary
  Widget order_summary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Shadow color
            offset: Offset(0, 2), // Horizontal and vertical offset
            blurRadius: 6, // Spread of the shadow
            spreadRadius: 0, // Extend the shadow in all directions
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Order Items: ",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          for (var item in widget.cartItem)
            Row(
              children: [
                Text(
                  "${item.productName}  x${item.numOfItem}",
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Text(
                  'RM ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //bottom nav bar to make payment
  Widget bottom_nav_bar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 171, 10, 10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total Price :\n",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'RM ${widget.totalPrice.toStringAsFixed(2)}',
                        style:
                            const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () async {
                      //nav to Order Confirmation screen
                      if (widget.totalPrice < accAmount) {
                        accAmount -= widget.totalPrice;
                        String? orderId = await orderProvider.addOrder(
                            widget.cartItem, widget.totalPrice);
                        if (orderId!.isNotEmpty) {
                          //if account balance is enough
                          Navigator.pushNamed(
                            context,
                            OrderConfirmationScreen.routeName,
                            arguments: orderId,
                          );
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    const Text('Insufficient Account Amount'),
                                content: const Text(
                                    'Your account balance is not enough to make this payment.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(160, 50)), // Change the size as needed
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255,
                              255)), // Change the color to your desired color
                    ),
                    child: const Text(
                      "Make Payment",
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
