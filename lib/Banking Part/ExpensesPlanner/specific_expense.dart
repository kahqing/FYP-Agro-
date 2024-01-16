import 'package:agro_plus_app/Banking%20Part/ExpensesPlanner/category_list.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecificExpenseScreen extends StatefulWidget {
  final String id;
  final String category;
  final String title;
  final String amount;
  const SpecificExpenseScreen(
      {super.key,
      required this.id,
      required this.category,
      required this.title,
      required this.amount});

  @override
  State<SpecificExpenseScreen> createState() => _SpecificExpenseScreenState();
}

class _SpecificExpenseScreenState extends State<SpecificExpenseScreen> {
  Database db = Database();
  StatusMessage msg = StatusMessage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
                future: db.getExpenseInfo(
                    widget.id, widget.category, widget.title, widget.amount),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    Map<String, dynamic> expensesData = snapshot.data ?? {};

                    return Container(
                      margin: const EdgeInsets.all(30),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text(
                                  widget.category,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Amount Spent:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 255, 248, 225),
                              ),
                              child: Text("RM${expensesData['amount']}",
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Date:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 255, 248, 225),
                              ),
                              child: Text(expensesData['date'],
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Description:",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 255, 248, 225),
                              ),
                              child: Text(expensesData['description'],
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 20, top: 50),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          'assets/images/back.png',
                                          width:
                                              60, // Adjust the width as needed
                                          height:
                                              60, // Adjust the height as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 20, top: 50),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm Delete'),
                                              content: Text(
                                                  'Are you sure you want to delete this expense?'),
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
                                                    db.deleteExpenses(
                                                        widget.id,
                                                        widget.category,
                                                        widget.title,
                                                        widget.amount);
                                                    msg.showSuccessMessage(
                                                        "Deleted Successfully");
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          'assets/images/delete.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ],
        )),
      ),
    );
  }
}
