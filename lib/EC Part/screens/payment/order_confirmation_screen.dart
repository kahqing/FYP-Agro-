import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static String routeName = '/order_confirmation';

  final String orderId;

  OrderConfirmationScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 249, 176, 176),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fchecked.png?alt=media&token=e66a57ff-584d-4258-9c7b-03862769421b&_gl=1*rrr52y*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5OTM5OTYzOC42MC4xLjE2OTk0MDA5MDYuMzUuMC4w'),
            ),
            const SizedBox(height: 15),
            const Text(
              'Thank You for your purchase',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Payment done Successfully',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 100),
            Text(
              'Order ID: $orderId',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              //Navigate back to EC home screen
              Navigator.of(context).pushNamedAndRemoveUntil(
                  ECMainScreen.routeName, (Route<dynamic> route) => false);
            },
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 17),
            )),
      ),
    );
  }
}
