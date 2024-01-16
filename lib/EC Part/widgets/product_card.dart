import 'package:agro_plus_app/EC Part/models/product.dart';
import 'package:agro_plus_app/EC%20Part/screens/detail/fixed_price_detail_screen.dart';
import 'package:agro_plus_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FixedPriceProductCard extends StatelessWidget {
  FixedPriceProductCard({
    Key? key,
    this.width = 175, // Increase the width value to your desired size
    this.aspectRatio = 0.9, // Adjust the aspect ratio as needed
    required this.product,
  }) : super(key: key);

  final double width, aspectRatio;
  final Product product;
  String apiUrl = AppConfig.apiHostname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 10), //padding for starting the row of products
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () async {
            print("product id: ");
            print(product.id);
            final response = await http.post(
              Uri.parse('${AppConfig.apiHostname}incrementClicks'),
              body: {
                'productId': product.id
              }, // Pass the product ID or any necessary data
            );

            if (response.statusCode == 200) {
              // Successfully incremented click counter on the backend
              print('Successfully increment click counter');
            } else {
              // Handle error
              print('Failed to increment click counter on the backend.');
            }
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, DetailsScreen.routeName,
                arguments: ProductDetailsArguments(product: product));
          },
          child: Container(
            padding: const EdgeInsets.all(10), //padding inside the product card
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: aspectRatio, // Use the specified aspectRatio
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),

                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "RM${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF7643),
                  ),
                ),
                const SizedBox(height: 8),
                // Row(
                //   children: [
                //     Text(
                //       '${product.seller.name}',
                //       style: TextStyle(
                //         fontSize: 16,
                //       ),
                //     ),
                //     SizedBox(width: 15),
                //     Text(
                //       '${product.seller.location}',
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
