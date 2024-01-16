import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  static String routeName = '/comfirm_payment';
  final double totalPrice;
  final String matric;

  const ConfirmPaymentScreen({required this.totalPrice, required this.matric});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  bool isBalanceLoaded = false;
  late double balance;

  @override
  void initState() {
    super.initState();
    getCurrentBalance(widget.matric);
  }

  Future<double> getCurrentBalance(String matric) async {
    try {
      //fetch document snapshot
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(matric).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        double balance = userData['balance'].toDouble();
        if (balance > widget.totalPrice) {
          setState(() {
            isBalanceLoaded = true;
            this.balance = balance;
          });
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(
                    child: Text(
                  'Insufficient Account Amount',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
                content: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Your account balance is not enough to make the payment.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          //Navigator.pop(context);
        }

        print('user balance is loaded: $balance');
        return balance;
      } else {
        print('User document not found');
      }
    } catch (error) {
      print('Error fetching buyer data: $error');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isBalanceLoaded
          ? SingleChildScrollView(
              child: Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    // color: Color.fromARGB(255, 254, 225, 225),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 133, 34, 9),
                          Color.fromARGB(255, 248, 207, 72),
                        ]),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            //color: Color.fromARGB(255, 254, 225, 225),
                            // gradient: LinearGradient(
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight,
                            //     colors: [
                            //       Color.fromARGB(255, 133, 34, 9),
                            //       Color.fromARGB(255, 248, 207, 72),
                            //     ]),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.only(
                                top: 50, left: 20, right: 20, bottom: 80),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Set the result to true and pop the screen back to check out screen
                                Navigator.pop(context, 'payment_confirmed');
                              },
                              style: ElevatedButton.styleFrom(
                                  //fixedSize: const Size(300, 50),
                                  backgroundColor:
                                      const Color.fromARGB(255, 197, 0, 0),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                              child: const Text(
                                "Confirm Payment",
                                style: TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 18, 8, 8), // Shadow color
                        offset: Offset(0, 2), // Horizontal and vertical offset
                        blurRadius: 6, // Spread of the shadow
                        spreadRadius: 0, // Extend the shadow in all directions
                      ),
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topLeft,
                        colors: [
                          Color.fromARGB(255, 145, 4, 4),
                          Color.fromARGB(255, 198, 6, 6),
                        ]),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black45, // Set your dark color here
                        width: 2.0, // Adjust the border thickness as needed
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 120, left: 50, right: 50, bottom: 40),
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Your Balance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              //fontWeight: FontWeight.w400
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "RM ${balance.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Amount Needed to Pay",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "RM ${widget.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
