import 'package:agro_plus_app/EC%20Part/screens/auction/auction_history.dart';
import 'package:agro_plus_app/EC%20Part/screens/order/order_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_dashboard_screen.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';

import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final String matric;
  const CustomBottomNavigationBar({required this.matric});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromARGB(255, 166, 46, 46),
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        //height: kBottomNavigationBarHeight,
        height: 65.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomepageScreen(
                                matric: matric,
                              )));
                },
                child: const Column(
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3.0),
                    Text('Home',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuctionHistoryScreen(),
                  ),
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/testapp-f4cb8.appspot.com/o/icons%2Fauction.png?alt=media&token=e820c7d2-c5d3-4b17-ae83-c1ca4c85a08a&_gl=1*n5bq31*_ga*MTcxNTYyMzY4MC4xNjk2NzY5MDg4*_ga_CW55HF8NVT*MTY5ODkxMTkyNy40MS4xLjE2OTg5MTIwNTYuMTcuMC4w',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 3.0),
                    const Text('Auction',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SellerDashboard.routeName,
                      arguments: matric);
                },
                child: const Column(
                  children: [
                    Icon(
                      Icons.sell_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3.0),
                    Text('Seller',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              // GestureDetector for "Order"
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(
                        matric: matric,
                      ),
                    ),
                  );
                },
                child: const Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3.0),
                    Text('Order',
                        style: TextStyle(
                          color: Colors.white,
                        )),
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
