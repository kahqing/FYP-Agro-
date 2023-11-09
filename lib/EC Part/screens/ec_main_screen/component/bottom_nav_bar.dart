import 'package:agro_plus_app/EC%20Part/screens/seller/seller_dashboard_screen.dart';
import 'package:agro_plus_app/main.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: kBottomNavigationBarHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  //     Navigator.push(
                  // context,
                  // MaterialPageRoute(
                  //     builder: (context) => HomepageScreen(
                  //           username: username,
                  //         )));
                },
                child: const Column(
                  children: [
                    Icon(Icons.home_filled),
                    SizedBox(height: 3.0),
                    Text('Home'),
                  ],
                ),
              ),
              Column(
                children: [
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fauction.png?alt=media&token=e820c7d2-c5d3-4b17-ae83-c1ca4c85a08a&_gl=1*n5bq31*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTIwNTYuMTcuMC4w',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(height: 3.0),
                  Text('Auction'),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SellerDashboard.routeName,
                      arguments: userId);
                },
                child: const Column(
                  children: [
                    Icon(Icons.sell_rounded),
                    SizedBox(height: 3.0),
                    Text('Seller'),
                  ],
                ),
              ),
              // GestureDetector for "Order"
              GestureDetector(
                onTap: () {
                  // Navigate to Order History Screen
                  //Navigator.pushNamed(context, '/order_history');
                },
                child: const Column(
                  children: [
                    Icon(Icons.person),
                    SizedBox(height: 3.0),
                    Text('Order'),
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
