import 'package:agro_plus_app/EC%20Part/models/cart.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:agro_plus_app/EC Part/models/product.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    //instance of Product and CartProvider
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            final cartItem = Cart(
              productId: args.product.id,
              productName: args.product.name,
              price: args.product.price,
              image: args.product.image,
            );
            bool added = await cartProvider.addToCart(cartItem);
            if (added) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Successfully added to cart',
                    style: TextStyle(color: Colors.black),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  backgroundColor: Color.fromARGB(255, 179, 255, 179),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Item is already in cart.',
                    style: TextStyle(color: Colors.black),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  backgroundColor: Color.fromARGB(255, 179, 255, 179),
                ),
              );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: args.product.fetchUserData(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Container(
                      //width: 200,
                      height: 300,
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
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Match the borderRadius above
                        child: Image.network(
                          args.product.image,
                          width: 200,
                          fit: BoxFit.cover, // Adjust as needed
                        ),
                      ),
                    )),
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
                    const SizedBox(height: 10),
                    SizedBox(
                      child: Text('Category: ${args.product.category}'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Price: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'RM${args.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Created Time: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(DateFormat('yyyy-MM-dd hh:mm a')
                            .format(args.product.createdDate)),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    //use ternary operator (condition? trueWidget: falseWidget)
                    args.product.sellerData != null
                        ? Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seller: ${args.product.sellerData!['username']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Location: ${args.product.sellerData!['address']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),

                    const SizedBox(height: 20),

                    // Align(
                    //   alignment: Alignment.center,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       final cartItem = Cart(
                    //         productId: args.product.id,
                    //         productName: args.product.name,
                    //         price: args.product.price,
                    //         image: args.product.image,
                    //       );
                    //       cartProvider.addToCart(cartItem);
                    //     },
                    //     style: ButtonStyle(
                    //       minimumSize: MaterialStateProperty.all<Size>(
                    //           const Size(350, 40)), // Change the size as needed
                    //       shape: MaterialStateProperty.all<OutlinedBorder>(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(
                    //               30.0), // Adjust the radius as needed
                    //         ),
                    //       ),
                    //       backgroundColor: MaterialStateProperty.all<Color>(
                    //           const Color.fromARGB(255, 197, 0,
                    //               0)), // Change the color to your desired color
                    //     ),
                    //     child: const Text(
                    //       "Add to Cart",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }
            })),
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
