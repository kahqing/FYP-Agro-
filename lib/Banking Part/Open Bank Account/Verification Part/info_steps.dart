import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Payment%20Part/payment_info.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_capture_ic.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepsInfoScreen extends StatefulWidget {
  final String id;
  const StepsInfoScreen({super.key, required this.id});

  @override
  State<StepsInfoScreen> createState() => _StepsInfoScreenState();
}

class _StepsInfoScreenState extends State<StepsInfoScreen> {
  late Future<String> status;
  Database db = Database();

  @override
  void initState() {
    super.initState();
    status = db.getStatusStep1(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      body: FutureBuilder<String>(
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

            return buildUIBasedOnStatus(status, id);
          }
        },
      ),
    );
  }

  Widget buildUIBasedOnStatus(String status, String id) {
    if (status == 'Not done') {
      return Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    const Text(
                      "Let's do it in 2 steps.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Identity Verification",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          Text(
                            "You need to verify your identity and fill up online application form. Your info will be stored securely.",
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 163, 163, 163).withOpacity(0.9),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment for Initial Deposit",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Color.fromARGB(255, 70, 70, 70)),
                          ),
                          Text(
                              "You need to deposit a minimum of RM50.00 for activating your account.",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 70, 70, 70)))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  CaptureICInfoScreen(id: id)));
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
              )
            ],
          ),
        ),
      );
    } else if (status == 'Done') {
      return Container(
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
        // UI for not captured status
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  const Text(
                    "Let's finish the last step.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 152, 152, 152).withOpacity(0.9),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Identity Verification",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Color.fromARGB(255, 70, 70, 70)),
                        ),
                        Text(
                          "You need to verify your identity and fill up online application form. Your info will be stored securely.",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 70, 70, 70)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment for Initial Deposit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                        Text(
                            "You need to deposit a minimum of RM20.00 for activating your account.",
                            style: TextStyle(fontSize: 13))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PaymentScreen(id: id)));
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  )),
            )
          ],
        ),
      );
    } else {
      // Handle other status values if needed
      return Center(
        child: Text('Unknown Status: $status'),
      );
    }
  }
}
