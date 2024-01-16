import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/complete_goal.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/goal_details.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class GoalFundScreen extends StatefulWidget {
  final String id;
  final String category;
  final String title;
  const GoalFundScreen(
      {super.key,
      required this.id,
      required this.category,
      required this.title});

  @override
  State<GoalFundScreen> createState() => _GoalFundScreenState();
}

class _GoalFundScreenState extends State<GoalFundScreen> {
  Database db = Database();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusMessage msg = StatusMessage();
  DateTime dateNow = DateTime.now();

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(255, 208, 46, 46),
                  Color.fromARGB(255, 127, 18, 18)
                ])),
            child: const Center(
              child: Text(
                "Please enter your amount.",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 170),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              child: FutureBuilder<Map<String, dynamic>>(
                  future:
                      db.getGoalInfo(widget.id, widget.category, widget.title),
                  builder: (context, snapshot) {
                    Map<String, dynamic> goalData = snapshot.data ?? {};
                    return Container(
                      margin: const EdgeInsets.all(30),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FutureBuilder<Map<String, dynamic>>(
                                future: db.getGoalInfo(
                                    widget.id, widget.category, widget.title),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.data == null) {
                                    return Text('No data available');
                                  } else {
                                    return Text(
                                      "Remaining Amount: RM${(double.parse(goalData['target']) - goalData['currentAmount']).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    );
                                  }
                                }),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: amountController,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: const Color.fromARGB(
                                              255, 101, 101, 101)
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
                            Container(
                              margin: const EdgeInsets.only(top: 280),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 160, 24, 14)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                  ),
                                  Container(
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 160, 24, 14)),
                                        onPressed: () {
                                          //ensure the amount is not over than target

                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (goalData['currentAmount']
                                                        .toDouble() +
                                                    double.parse(
                                                        amountController
                                                            .text) <=
                                                double.parse(
                                                    goalData['target'])) {
                                              if (goalData['currentAmount']
                                                          .toDouble() +
                                                      double.parse(
                                                          amountController
                                                              .text) ==
                                                  double.parse(
                                                      goalData['target'])) {
                                                if (daysBetween(
                                                        dateNow,
                                                        DateTime.parse(goalData[
                                                            'endDate'])) >=
                                                    0) {
                                                  db.updateCurrentAmount(
                                                      widget.id,
                                                      double.parse(
                                                          amountController
                                                              .text),
                                                      widget.category,
                                                      widget.title);

                                                  db.updateTabungAmount(
                                                      widget.id,
                                                      double.parse(
                                                          amountController
                                                              .text),
                                                      false);

                                                  db.updateStatusGoal(
                                                      widget.id,
                                                      widget.category,
                                                      widget.title);

                                                  msg.showSuccessMessage(
                                                      "Successfully Payment!");
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CongratCompletedGoalScreen(
                                                              id: widget.id,
                                                              category: widget
                                                                  .category,
                                                              title:
                                                                  widget.title),
                                                    ),
                                                  );
                                                } else {
                                                  db.updateCurrentAmount(
                                                      widget.id,
                                                      double.parse(
                                                          amountController
                                                              .text),
                                                      widget.category,
                                                      widget.title);

                                                  db.updateTabungAmount(
                                                      widget.id,
                                                      double.parse(
                                                          amountController
                                                              .text),
                                                      false);

                                                  db.updateStatusGoal(
                                                      widget.id,
                                                      widget.category,
                                                      widget.title);

                                                  msg.showSuccessMessage(
                                                      "Successfully Payment!");
                                                  Navigator.of(context).pop();
                                                }
                                              } else {
                                                db.updateCurrentAmount(
                                                    widget.id,
                                                    double.parse(
                                                        amountController.text),
                                                    widget.category,
                                                    widget.title);

                                                db.updateTabungAmount(
                                                    widget.id,
                                                    double.parse(
                                                        amountController.text),
                                                    false);

                                                msg.showSuccessMessage(
                                                    "Successfully Payment!");
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              msg.showUnsuccessMessage(
                                                  "Over amount");
                                            }
                                          } else {
                                            msg.showUnsuccessMessage("Failed!");
                                          }
                                        },
                                        child: const Text(
                                          "Pay",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
