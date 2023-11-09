import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/make_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart_screen";
  final String matric;

  CartScreen({required this.matric});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> demoCarts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: cartItem(), //use cart data from cart provider
      bottomNavigationBar: checkoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: Color.fromARGB(255, 197, 0, 0),
      elevation: 5,
      title: Column(
        children: [
          const Text(
            "Your Cart",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<CartProvider>(
            //consumer widget to access item from cart provider
            builder: (context, cartProvider, child) {
              return Text(
                "${cartProvider.cartList.length} items",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ECMainScreen.routeName);
          },
          icon: const Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }

  double calculateTotalPrice(List<Cart> cartList) {
    double total = 0.0;
    for (final cart in cartList) {
      total += cart.price;
    }
    return total;
  }

  Widget cartItem() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        cartProvider.loadCartData();
        demoCarts = cartProvider.cartList;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: demoCarts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: cart_card(cart: demoCarts[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete), // Use the trash can icon
                        onPressed: () {
                          cartProvider
                              .deleteCartItem(demoCarts[index].productId);
                          print('itemId: ${demoCarts[index].productId}');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget cart_card({required Cart cart}) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.network(cart.image),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.productName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "RM${cart.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 179, 52, 6)),
                  children: [
                    TextSpan(
                      text: "   x${cart.numOfItem}",
                      //style: Theme.of(context).textTheme.bodyText1
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget checkoutCard() {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      demoCarts = cartProvider.cartList;
      double total = calculateTotalPrice(demoCarts);
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
                      text: "Total:\n",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "RM ${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                    matric: cartProvider.matric,
                                    cartItem: demoCarts,
                                    totalPrice: total)));
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(150, 50)), // Change the size as needed
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 255,
                                255)), // Change the color to your desired color
                      ),
                      child: const Text(
                        "Check Out",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
