import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Product.dart';

import '../cart/cart_screen.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    //instance of Product and CartProvider
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 300,
                child: Image.network(
                  args.product.image,
                  width: 200,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              args.product.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            //description
            Text(
              args.product.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            // Row(
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Seller: ${args.product.seller.name}',
            //           style: TextStyle(fontSize: 16, color: Colors.grey),
            //         ),
            //         SizedBox(height: 10),
            //         Text(
            //           'Location: ${args.product.seller.location}',
            //           style: TextStyle(fontSize: 16, color: Colors.grey),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Price: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'RM${args.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Spacer(), // This will push the following content to the bottom
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  final cartItem = Cart(
                    productId: args.product.id,
                    productName: args.product.name,
                    price: args.product.price,
                    image: args.product.image,
                  );
                  cartProvider.addToCart(cartItem);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(300, 50)), // Change the size as needed
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 17, 16,
                          14)), // Change the color to your desired color
                ),
                child: Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  //final Seller seller;

  ProductDetailsArguments({
    required this.product,
    //required this.seller,
  });
}
