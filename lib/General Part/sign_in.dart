import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/notification/winner_notification_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signin.dart';
import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:agro_plus_app/General%20Part/sign_up.dart';
import 'package:agro_plus_app/matric_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> userLogin(matric, password) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('user');

    try {
      // Query Firestore for the user document based on the username.
      final DocumentReference documentReference = usersCollection.doc(matric);

      final DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;

        String storedPassword = data['password'];

        if (storedPassword == password) {
          final firebaseMessaging = FirebaseMessaging.instance;
          await FirebaseMessaging.instance.requestPermission();
          final fcmToken = await firebaseMessaging.getToken();
          print('FCM Token: $fcmToken');
          final CollectionReference ref =
              FirebaseFirestore.instance.collection("user");
          ref.doc(matric).update({
            "fcmToken": fcmToken,
          });

          // Pass matric to CartProvider
          Provider.of<CartProvider>(context, listen: false)
              .updateMatric(matric);
          // Pass matric to OrderProvider
          Provider.of<OrderProvider>(context, listen: false)
              .updateMatric(matric);

          //update and save matric to sharedPreferences (matricStorage)
          MatricStorage().saveMatric(matric);

          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return Center(child: CircularProgressIndicator());
          //     });
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomepageScreen(
                        matric: matric,
                      )));

          // Navigator.of(context).pop();
        } else {
          const snackBar = SnackBar(
            content: Text(
              "Incorrect Username or Password.",
              style: TextStyle(color: Colors.black),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            backgroundColor: Color.fromARGB(255, 245, 179, 255),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        const snackBar = SnackBar(
          content: Text(
            "Incorrect Username or Password.",
            style: TextStyle(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          backgroundColor: Color.fromARGB(255, 245, 179, 255),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text(
          "Error occured.",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        backgroundColor: Color.fromARGB(255, 245, 179, 255),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _checkAndNavigate(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasNotification = prefs.getBool('hasNotification') ?? false;
    print('checkede has notification: $hasNotification');

    if (hasNotification) {
      final String? messageJson = prefs.getString('notificationMessage');

      if (messageJson != null) {
        Map<String, dynamic> messageData = json.decode(messageJson);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, WinnerNotificationScreen.routeName,
            arguments: {"message": json.encode(messageData)});
      }

      // Clear the notification flag and message from SharedPreferences
      await prefs.setBool('hasNotification', false);
      await prefs.remove('notificationMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Color.fromARGB(255, 229, 48, 48),
                      Color.fromARGB(255, 127, 18, 18)
                    ])),
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: TextFormField(
                            controller: userController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8)),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                labelText: "Matric Number"),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              labelText: "Password"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password!";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  SellerSignInScreen.routeName,
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Click for '),
                                    TextSpan(
                                        text: 'Seller',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' Login'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true; // Set loading state to true
                              });

                              try {
                                await userLogin(
                                    userController.text, passController.text);
                              } catch (error) {
                                print("$error");
                              } finally {
                                setState(() {
                                  isLoading =
                                      false; // Set loading state to false
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              "LOG IN",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Dont have an account? ",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Image.asset("assets/agrobankLogo.png"),
                ),
              ),
            ],
          )),
          if (isLoading) // Display loading overlay when isLoading is true
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitFadingCube(
                  size: 50,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
