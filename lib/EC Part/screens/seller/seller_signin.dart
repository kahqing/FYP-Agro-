import 'dart:convert';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_menu.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signup.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SellerSignInScreen extends StatefulWidget {
  static String routeName = '/seller_login';
  String apiUrl = AppConfig.apiHostname;

  SellerSignInScreen({super.key});

  @override
  State<SellerSignInScreen> createState() => _SellerSignInScreenState();
}

class _SellerSignInScreenState extends State<SellerSignInScreen> {
  TextEditingController sellerIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> sellerLogin(String sellerId, String password) async {
    try {
      CollectionReference sellersCollection =
          FirebaseFirestore.instance.collection('seller');

      // Query Firestore for the user document based on the username.
      final DocumentReference documentReference =
          sellersCollection.doc(sellerId);

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
              FirebaseFirestore.instance.collection("seller");
          ref.doc(sellerId).update({
            "fcmToken": fcmToken,
          });
          // ignore: use_build_context_synchronously
          Provider.of<ProductProvider>(context, listen: false)
              .updateSellerId(sellerId);

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(
            context,
            SellerMenuScreen.routeName,
            arguments: sellerId,
          );
        } else {
          const snackBar = SnackBar(
            content: Text(
              "Incorrect Seller ID or Password.",
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
            "Incorrect Seller ID or Password.",
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    Color.fromARGB(255, 40, 19, 96),
                    Color.fromARGB(255, 96, 114, 204),
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
                          controller: sellerIdController,
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
                              labelText: "Seller ID"),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
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
                                SignInScreen.routeName,
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: 'Click for '),
                                  TextSpan(
                                      text: 'Buyer',
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
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
                            await sellerLogin(sellerIdController.text,
                                passwordController.text);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            "LOG IN AS SELLER",
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
                          "Don't have a seller account? ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, SellerSignUpScreen.routeName);
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
            )
          ],
        ),
      ),
    );
  }
}
