import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/ekyc_form_1.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_open_acc.dart';

import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomepageScreen extends StatefulWidget {
  final String matric;
  const HomepageScreen({super.key, required this.matric});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
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

  @override
  Widget build(BuildContext context) {
    String matric = widget.matric;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromARGB(255, 229, 48, 48),
                            Color.fromARGB(255, 127, 18, 18)
                          ]),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      // margin: const EdgeInsets.only(left: 40),
                      child: Column(
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
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 120, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             CaptureBackICScreen(id: matric)));
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('Account'),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             EKYCFormScreen()));
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('Transfer'),
                                      ],
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             FaceCompareScreen(id: matric)));
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('Expenses'),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ECMainScreen(matric: matric),
                                    ),
                                  );
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('Shopping'),
                                      ],
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EKYCFormScreen(
                                                id: matric,
                                              )));
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('Goals'),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 150,
                            width: 150,
                            child: Card(
                              elevation: 5,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor:
                                    const Color.fromARGB(255, 171, 171, 171)
                                        .withAlpha(20),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/agrobankLogo.png"),
                                        const Text('blablaba'),
                                      ],
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 120, left: 50),
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 70),
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 160, 24, 14)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OpenAccInfoScreen(id: matric)));
                  },
                  child: const Text(
                    "Create your own Agrobank account",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
