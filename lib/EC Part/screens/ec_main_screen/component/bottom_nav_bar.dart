import 'package:agro_plus_app/EC%20Part/screens/auction/auction_history.dart';
import 'package:agro_plus_app/EC%20Part/screens/cart/cart_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/order/order_screen_buyer.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final String matric;

  const CustomBottomNavigationBar({required this.matric});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 166, 46, 46),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuctionHistoryScreen(matric: matric),
                  ),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/agroplus-app.appspot.com/o/icons%2Fauction.png?alt=media&token=c779ceaa-87aa-4598-82dd-5797a14f1844',
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(matric: matric),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(height: 3.0),
                  Text('Cart',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     // Navigator.pushNamed(context, SellerDashboard.routeName,
            //     //     arguments: matric);
            //     Navigator.pushNamed(
            //       context,
            //       SellerLogInScreen.routeName,
            //     );
            //   },
            //   child: const Column(
            //     children: [
            //       Icon(
            //         Icons.sell_rounded,
            //         color: Colors.white,
            //       ),
            //       SizedBox(height: 3.0),
            //       Text('Seller',
            //           style: TextStyle(
            //             color: Colors.white,
            //           )),
            //     ],
            //   ),
            // ),
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
                    Icons.assignment_ind_rounded,
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
    );
  }
}
