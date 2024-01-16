import 'package:agro_plus_app/EC%20Part/screens/payment/confirm_payment_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/prepare_checkout.dart';
import 'package:flutter/material.dart';

class CheckOutScreenContent extends StatelessWidget {
  String userAddress;
  final String matric;
  final String userName;
  final String contactNum;
  final double totalPrice;
  final Future<void> Function() onMakePaymentPressed;

  final List<SellerGroup> sellerGroupData;

  CheckOutScreenContent({
    required this.userAddress,
    required this.matric,
    required this.userName,
    required this.contactNum,
    required this.totalPrice,
    required this.sellerGroupData,
    required this.onMakePaymentPressed,
  });

  @override
  Widget build(BuildContext context) {
    //text controller for user address
    TextEditingController addressController = TextEditingController();
    addressController.text = userAddress;
    FocusNode addressFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(255, 255, 237, 237),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                ),
                child: Text(
                  'Delivery address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 220, 220),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                //alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$userName  $contactNum',
                            style: const TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              //prefixIcon: const Icon(Icons.location_on, size: 24),
                              suffixIcon: InkWell(
                                onTap: () {
                                  addressFocusNode.requestFocus();
                                },
                                child: const Icon(Icons.edit, size: 24),
                              ),
                            ),
                            style: const TextStyle(fontSize: 17),
                            controller: addressController,
                            focusNode: addressFocusNode,
                            onChanged: (value) {
                              userAddress = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                ),
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              for (var sellerGroup in sellerGroupData)
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 225, 220, 220),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Seller: ${sellerGroup.sellerName}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Divider(),
                      for (var item in sellerGroup.cartItems)
                        Row(
                          children: [
                            Text(
                              "${item.productName}  x${item.numOfItem}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              'RM ${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      const Divider(),
                      //const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Subtotal: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            'RM ${sellerGroup.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "Tax (${sellerGroup.tax}%): ",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            'RM ${sellerGroup.taxAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            "Delivery Fee: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            'RM ${sellerGroup.deliveryFee.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Text(
                            "Total: ",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            'RM ${sellerGroup.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 171, 10, 10),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
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
                      text: "Total Price :\n",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'RM ${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Navigate to ConfirmPaymentScreen and wait for result
                        final result = await Navigator.pushNamed(
                          context,
                          ConfirmPaymentScreen.routeName,
                          arguments: {
                            'totalPrice': totalPrice,
                            'matric': matric,
                          },
                        );

                        // If payment was confirmed, invoke onMakePaymentPressed
                        if (result != null) {
                          // If payment was confirmed, invoke onMakePaymentPressed
                          await onMakePaymentPressed();
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(300, 50)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 255, 255)),
                      ),
                      child: const Text(
                        "Make Payment",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
