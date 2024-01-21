import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';
import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Saving%20Homepage/success_withdraw.dart';
import 'package:agro_plus_app/Banking%20Part/messages.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/material.dart';

class WithdrawPocketScreen extends StatefulWidget {
  final String id;

  const WithdrawPocketScreen({
    super.key,
    required this.id,
  });

  @override
  State<WithdrawPocketScreen> createState() => _WithdrawPocketScreenState();
}

class _WithdrawPocketScreenState extends State<WithdrawPocketScreen> {
  Database db = Database();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StatusMessage msg = StatusMessage();
  late Future<String> tabungAmount;

  @override
  void initState() {
    fetchTabungAmount();

    super.initState();
  }

  void fetchTabungAmount() async {
    tabungAmount = db.getTabungAmount(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
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
                "Please enter withdrawal amount.",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 300),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              child: FutureBuilder<String>(
                  future: tabungAmount,
                  builder: (context, snapshot) {
                    String tabungAmount = snapshot.data ?? '';
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        margin: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                    labelText: "Amount (RM)",
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                            if (double.parse(amountController
                                                        .text) <=
                                                    double.parse(
                                                        tabungAmount) &&
                                                double.parse(tabungAmount) >
                                                    0) {
                                              db.updateBalance(
                                                  widget.id,
                                                  double.parse(
                                                      amountController.text),
                                                  false);

                                              db.updateTabungAmount(
                                                  widget.id,
                                                  double.parse(
                                                      amountController.text),
                                                  true);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SuccessWithdrawScreen(),
                                                ),
                                              );
                                            } else {
                                              msg.showUnsuccessMessage(
                                                  "Insufficient Pocket!");
                                            }
                                          } else {
                                            msg.showUnsuccessMessage("Failed!");
                                          }
                                        },
                                        child: const Text(
                                          "Withdraw",
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
