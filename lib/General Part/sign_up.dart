import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController matricController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";

  Future<void> userRegister(
      username, phone, password, email, address, matric) async {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection("user");
    ref.doc(matric).set({
      'username': username,
      'phone': phone,
      'password': password,
      "email": email,
      "address": address,
      "matric": matric,
      "statusAcc":
          "Not active", //it is for checking whether open acc alrdy or not
      "statusIcFront": "Not Captured",
      "statusIcBack": "Not Captured",
      "statusFace": "Not Captured",
      "frontIC": "",
      "backIC": "",
      "ic": "",
      "balance": "0"
    });
  }

  void clearText() {
    userController.clear();
    emailController.clear();
    passController.clear();
    phoneController.clear();
    matricController.clear();
    addressController.clear();
    confirmpassController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sign Up",
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
                Color.fromARGB(255, 229, 48, 48),
                Color.fromARGB(255, 127, 18, 18)
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
                        controller: userController,
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
                            labelText: "Username"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your username!";
                          } else {
                            return null;
                          }
                        },
                        // onChanged: (value) {
                        //   setState(() {
                        //     username = value;
                        //   });
                        // },
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     username = value;
                        //   });
                        // },
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     email = value;
                        //   });
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
                            labelText: "Contact"),
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     phone = value;
                        //   });
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     username = value;
                        //   });
                        // },
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
                        // onChanged: (value) {
                        //   setState(() {
                        //     confirm = value;
                        //   });
                        // },
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
                              await userRegister(
                                      userController.text,
                                      phoneController.text,
                                      passController.text,
                                      emailController.text,
                                      addressController.text,
                                      matricController.text)
                                  .then((value) {
                                clearText();
                                final snackBar = SnackBar(
                                  content: const Text(
                                    "User Registered.",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  action: SnackBarAction(
                                    label: "Log In",
                                    textColor: Colors.black,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, SignInScreen.routeName);
                                    },
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 102, 235, 122),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
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
                                    Color.fromARGB(255, 102, 235, 122),
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
                            "SIGN UP",
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
