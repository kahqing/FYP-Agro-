import 'package:agro_plus_app/EC%20Part/models/cartItem.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:agro_plus_app/EC Part/models/product.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/fixed_price_details";

  @override
  Widget build(BuildContext context) {
    //instance of Product and CartProvider
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 237, 237),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () async {
            final cartItem = CartItem(
              productId: args.product.id,
              productName: args.product.name,
              price: args.product.price,
              image: args.product.image,
              sellerId: args.product.sellerId,
            );
            final result = await cartProvider.addToCart(cartItem);
            if (result == AddToCartResult.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Item added to cart successfully',
                    style: TextStyle(color: Colors.black),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 179, 255, 179),
                ),
              );
            } else if (result == AddToCartResult.alreadyInCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Item is already in the cart',
                    style: TextStyle(color: Colors.black),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  backgroundColor: Color.fromARGB(255, 255, 240, 179),
                ),
              );
            } else {
              // Handle other cases if needed
            }
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(
                const Size(350, 40)), // Change the size as needed
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0), // Adjust the radius as needed
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(
                    255, 197, 0, 0)), // Change the color to your desired color
          ),
          child: const Text(
            "Add to Cart",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: args.product.fetchSellerData(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //width: double.infinity,
                    height: 300,
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          offset: Offset(0, 2), // Changes position of shadow
                          blurRadius: 6, // Changes size of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Match the borderRadius above
                      child: Image.network(
                        args.product.image,
                        width: 250,
                        fit: BoxFit.cover, // Adjust as needed
                      ),
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 40, right: 20, left: 20),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  spreadRadius: 0,
                                  offset: Offset(0, -2),
                                )
                              ]),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  args.product.category,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      args.product.name,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'RM${args.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                args.product.brand != null &&
                                        args.product.brand != ''
                                    ? RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Brand: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: args.product.brand,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                //model
                                args.product.model != null &&
                                        args.product.model != ''
                                    ? RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            const TextSpan(
                                              text: 'Model: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: args.product.model,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                Text(
                                  args.product.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text(
                                      'Publish Time: ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(args.product.createdDate),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                args.product.sellerData != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Seller: ${args.product.sellerData!['sellerName']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  'Location: ${args.product.sellerData!['address']}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: 50,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              );
            }
          })),
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
