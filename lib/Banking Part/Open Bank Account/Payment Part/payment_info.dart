import 'dart:math';

import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Payment%20Part/done_payment.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String id;
  const PaymentScreen({super.key, required this.id});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Database db = Database();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusMessage msg = StatusMessage();

  String generateAccNum() {
    var number = "";
    var randomnumber = Random();
    //chnage i < 15 on your digits need
    for (var i = 0; i < 12; i++) {
      number = number + randomnumber.nextInt(9).toString();
    }
    var accNum = "4173$number";
    return accNum;
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      body: Stack(
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
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 170),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "You need to pay RM20.00 for activating the bank account.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: amountController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 101, 101, 101)
                                          .withOpacity(0.8),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 255, 255, 255)
                                        .withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                labelText: "Amount",
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your Amount!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 160, 24, 14)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          ),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 160, 24, 14)),
                                onPressed: () {
                                  //ensure the amount is not over than target

                                  if (_formKey.currentState!.validate()) {
                                    if (double.parse(amountController.text) ==
                                        20) {
                                      db.updateBalance(
                                          widget.id,
                                          double.parse(amountController.text),
                                          false);

                                      db.updateStatusAcc(widget.id);

                                      db.updateAccNum(id, generateAccNum());

                                      msg.showSuccessMessage(
                                          "Successfully Payment!");

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DonePaymentScreen(
                                                    id: widget.id),
                                          ));
                                    } else {
                                      msg.showUnsuccessMessage(
                                          "You need to pay RM20 for activation!");
                                    }
                                  } else {
                                    msg.showUnsuccessMessage("Failed!");
                                  }
                                },
                                child: const Text(
                                  "Pay",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
