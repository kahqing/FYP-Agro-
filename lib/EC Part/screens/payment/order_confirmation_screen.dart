import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static String routeName = '/order_confirmation';
  final String matric;
  //final String orderId;

  OrderConfirmationScreen({
    required this.matric,
    //required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color.fromARGB(255, 197, 0, 0),
          elevation: 5,
          centerTitle: true,
          title: const Text(
            'Order Confirmation',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        //backgroundColor: Color.fromARGB(255, 249, 176, 176),
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
                'Thank you for your purchase',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Payment done Successfully',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 100),
              // Text(
              //   'Order ID: $orderId',
              // ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  //fixedSize: const Size(300, 50),
                  backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
              onPressed: () {
                //Navigate back to EC home screen

                Navigator.of(context).pushNamedAndRemoveUntil(
                  ECMainScreen.routeName,
                  (Route<dynamic> route) => false,
                  arguments: {'matric': matric},
                );
              },
              child: const Text(
                'Back To Shopping',
                style: TextStyle(fontSize: 17, color: Colors.white),
              )),
        ),
      ),
    );
  }
}
