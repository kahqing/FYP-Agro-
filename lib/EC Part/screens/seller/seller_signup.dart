import 'dart:convert';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signin.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SellerSignUpScreen extends StatefulWidget {
  static String routeName = "/seller_sign_up";
  const SellerSignUpScreen({super.key});

  @override
  State<SellerSignUpScreen> createState() => _SellerSignUpScreenState();
}

class _SellerSignUpScreenState extends State<SellerSignUpScreen> {
  TextEditingController sellerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController matricController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";
  String sellerId = "";
  bool hasSellerId = false;

  Future<void> sellerRegister(
      sellerName, phone, password, email, address, matric) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    await generateSellerId(matric);

    final CollectionReference sellerRef =
        FirebaseFirestore.instance.collection("seller");

    if (sellerId.isNotEmpty) {
      sellerRef.doc(sellerId).set({
        "sellerId": sellerId,
        'sellerName': sellerName,
        'phone': phone,
        'password': password,
        "email": email,
        "address": address,
        "matric": matric,
        "fcmToken": fcmToken,
      });

      final CollectionReference userRef =
          FirebaseFirestore.instance.collection("user");

      if (sellerId.isNotEmpty) {
        userRef.doc(matric).update({
          'sellerId': sellerId,
        });
      }

      //get FCM token for the device
    }
  }

  void clearText() {
    sellerNameController.clear();
    emailController.clear();
    passController.clear();
    phoneController.clear();
    matricController.clear();
    addressController.clear();
    confirmpassController.clear();
  }

  Future<bool> checkSellerId(String matric) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiHostname}checkSellerId/$matric'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        hasSellerId = data['hasSellerId'];
        print(hasSellerId);

        setState(() {
          if (hasSellerId) {
            sellerId = data['sellerId'];

            print('Fetched Seller ID: $sellerId');
          } else {
            print("User has no seller id.");
          }
        });
        return hasSellerId;
      } else {
        print('Failed to fetch Seller ID. Status code: ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('Error checking seller ID: $e');
    }
    return false;
  }

  Future<void> generateSellerId(String matric) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiHostname}generateSellerId/$matric'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        //final String generatedSellerId = data['sellerId'];
        setState(() {
          sellerId = data['sellerId'];
          hasSellerId = false;
        });

        print('Generated Seller ID: $sellerId');
      } else {
        print(
            'Failed to generate seller ID. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error generating seller ID: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Create Seller Account",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                Color.fromARGB(243, 81, 110, 252),
                Color.fromARGB(255, 56, 38, 106),
              ])),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: sellerNameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
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
                            labelText: "Seller Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your seller name!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: matricController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
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
                            labelText: "Matric Number"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your matric number!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
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
                            labelText: "Email"),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Please enter your email!";
                        //   } else if (!value.contains('@')) {
                        //     return "Please enter valid email";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
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
                            labelText: "Contact Number"),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Please enter your phone number!";
                        //   } else if (num.tryParse(value) != null &&
                        //       (value.length != 11 || value.length != 10)) {
                        //     return "Please enter a valid phone number format!";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
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
                            labelText: "Address"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your address!";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: passController,
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
                        // validator: (value) {
                        //   RegExp regex = RegExp(
                        //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        //   if (value!.isEmpty) {
                        //     return "Please enter your password!";
                        //   } else if (!regex.hasMatch(value)) {
                        //     return "The password must have at least 8 characters in length, one uppercase, one lowercase, one digit, and one special character.";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: confirmpassController,
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
                            labelText: "Confirm Password"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please confirm your password!";
                          } else if (value != password) {
                            return "Password does not match";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool check =
                                  await checkSellerId(matricController.text);

                              if (check) {
                                const snackBar = SnackBar(
                                  content: Text(
                                    "Seller Account is created before.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                await sellerRegister(
                                        sellerNameController.text,
                                        phoneController.text,
                                        passController.text,
                                        emailController.text,
                                        addressController.text,
                                        matricController.text)
                                    .then((value) {
                                  clearText();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Seller Registered"),
                                        content: Text(
                                          "Please Remember Your Seller ID: $sellerId",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                              Navigator.pushNamed(context,
                                                  SellerSignInScreen.routeName);
                                            },
                                            child:
                                                const Text("Log In As Seller"),
                                          ),
                                        ],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              const snackbar = SnackBar(
                                content: Text(
                                  "User Registered Unsuccessfully.",
                                  style: TextStyle(color: Colors.black),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 245, 179, 255),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Text(
                            "SIGN UP AS SELLER",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
