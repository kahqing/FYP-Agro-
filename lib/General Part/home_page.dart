import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/game_homepage.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Payment%20Part/payment_info.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/ekyc_form_1.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_open_acc.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/select_branch.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';
import 'package:agro_plus_app/Database/db.dart';

import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  final String matric;
  const HomepageScreen({super.key, required this.matric});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  Database db = Database();
  late Future<String> status;

  late Future<String> balance;
  late Future<String> accNum;
  Future<String> getName(matric) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection("user");

      DocumentSnapshot document = await collection.doc(matric).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String username = data["username"];
        return username;
      } else {
        return "";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> refreshData() async {
    String balanceAmountResult = await db.getBalance(widget.matric);

    setState(() {
      balance = Future.value(balanceAmountResult);
    });
  }

  @override
  void initState() {
    super.initState();
    status = db.getStatusAcc(widget.matric);
    fetchBalance();
    fetchAcc();
  }

  void fetchBalance() async {
    balance = db.getBalance(widget.matric);
  }

  void fetchAcc() async {
    accNum = db.getAccNum(widget.matric);
  }

  @override
  Widget build(BuildContext context) {
    String matric = widget.matric;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(80)),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // Color.fromARGB(255, 250, 114, 114),
                        // Color.fromARGB(255, 255, 79, 79),
                        Color.fromARGB(255, 239, 37, 37),
                        Color.fromARGB(255, 127, 18, 18)
                      ]),
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  // margin: const EdgeInsets.only(left: 40),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 20),
                              FutureBuilder<String>(
                                future: getName(matric),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "Hello, Loading...",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      "Hello, Error: ${snapshot.error}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      "Hello, ${snapshot.data}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const Text("How are you today?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Logout'),
                                    content: Text(
                                        'Are you sure you want to logout?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInScreen(),
                                              ),
                                              (route) => false);
                                        },
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      FutureBuilder<String>(
                        future: status,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Future is still loading, show a loading indicator or placeholder
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            // Future encountered an error, handle the error
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // Future has completed successfully, use the result to build UI
                            String status = snapshot.data ??
                                ''; // Use a default value if needed

                            return buildUIBasedOnStatus(status, matric);
                          }
                        },
                      ),
                    ],
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: FutureBuilder<String>(
                  future: status,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Future is still loading, show a loading indicator or placeholder
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Future encountered an error, handle the error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Future has completed successfully, use the result to build UI
                      String status =
                          snapshot.data ?? ''; // Use a default value if needed

                      return DisableButtonBasedOnStatus(status, matric);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget buildUIBasedOnStatus(String status, String id) {
    if (status == 'Not active') {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 70),
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 160, 24, 14)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OpenAccInfoScreen(id: id)));
          },
          child: const Text(
            "Create your own Agrobank account",
            style: TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (status == 'Active') {
      return Center(
          child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              FutureBuilder<String>(
                future: accNum,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String accountNum = snapshot.data ?? '';
                    return Column(
                      children: [
                        Text("ACCOUNT NUMBER:",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 255, 255, 255))),
                        Text(
                          accountNum,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 40,
              ),
              FutureBuilder<String>(
                future: balance,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String balanceAmount = snapshot.data ?? '';
                    return Column(
                      children: [
                        Text(
                          "BALANCE:",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        Text(
                          'RM$balanceAmount',
                          style: TextStyle(fontSize: 21, color: Colors.white),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ));
    } else {
      // Handle other status values if needed
      return Center(
        child: Text('Unknown Status: $status'),
      );
    }
  }

  Widget DisableButtonBasedOnStatus(String status, String id) {
    if (status == 'Not active') {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 70),
          padding: const EdgeInsets.all(10),
          child: Text(
              "Please register your own Agrobank account for unlocking all the features."));
    } else if (status == 'Active') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: const Color.fromARGB(255, 171, 171, 171)
                            .withAlpha(20),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CaptureBackICScreen(id: matric)));
                        },
                        child:
                            // Container(
                            //     padding: const EdgeInsets.all(20),
                            //     child:
                            //         Icon(Icons.account_balance_wallet_rounded))
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/account.png",
                                      width: 120, // Adjust the width as needed
                                      height:
                                          120, // Adjust the height as needed
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                )),
                      ),
                    ),
                    const Text('Account'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: const Color.fromARGB(255, 171, 171, 171)
                            .withAlpha(20),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             EKYCFormScreen()));
                        },
                        child:
                            //  Container(
                            //     padding: const EdgeInsets.all(20),
                            //     child: Icon(Icons.payment_rounded)),

                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/transfer.png",
                                      width: 120, // Adjust the width as needed
                                      height:
                                          120, // Adjust the height as needed
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                )),
                      ),
                    ),
                    const Text('Transfer'),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: const Color.fromARGB(255, 171, 171, 171)
                            .withAlpha(20),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(matric: widget.matric)));
                        },
                        child:
                            // Container(
                            //     padding: const EdgeInsets.all(20),
                            //     child: Icon(Icons.book)),

                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/expenses.png",
                                      width: 120, // Adjust the width as needed
                                      height:
                                          120, // Adjust the height as needed
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                )),
                      ),
                    ),
                    const Text('Expenses'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: const Color.fromARGB(255, 171, 171, 171)
                            .withAlpha(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ECMainScreen(matric: widget.matric),
                            ),
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/shopping.png",
                                  width: 120, // Adjust the width as needed
                                  height: 120, // Adjust the height as needed
                                  fit: BoxFit.cover,
                                ),
                              ],
                            )),
                        // Container(
                        //     padding: const EdgeInsets.all(20),
                        //     child: Icon(Icons.shopify_rounded)),
                      ),
                    ),
                    const Text('Shopping'),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: const Color.fromARGB(255, 171, 171, 171)
                            .withAlpha(20),
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BottomNavigationBarScreen(
                                              id: widget.matric)))
                              .then((value) => refreshData());
                        },
                        child:
                            // Container(
                            //     padding: const EdgeInsets.all(20),
                            //     child: Icon(Icons.attach_money_outlined)),

                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  "assets/saving_goals.jpg",
                                  width: 120, // Adjust the width as needed
                                  height: 120, // Adjust the height as needed
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),
                    const Text('Goals'),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Handle other status values if needed
      return Center(
        child: Text('Unknown Status: $status'),
      );
    }
  }
}
