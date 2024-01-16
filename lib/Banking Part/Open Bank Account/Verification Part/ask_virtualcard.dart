import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/done_verification.dart';
import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/select_branch.dart';
import 'package:agro_plus_app/Database/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskVirtualCard extends StatefulWidget {
  final String id;

  const AskVirtualCard({
    super.key,
    required this.id,
  });

  @override
  State<AskVirtualCard> createState() => _AskVirtualCardState();
}

class _AskVirtualCardState extends State<AskVirtualCard> {
  String selectedCardType = '';
  Database db = Database();
  TextEditingController branchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(40),
                      child: const Text(
                        "Please Select One",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    buildCard("Physical Card"),
                    buildCard("Virtual Card"),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      if (selectedCardType == 'Physical Card') {
                        db.updateCardType("Yes", widget.id);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SelectBranchScreen(
                                      id: widget.id,
                                    )));
                      } else {
                        db.updateCardType("No", widget.id);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    SuccessVerifyScreen(id: widget.id)));
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    )),
              )
            ]),
      ),
    );
  }

  Widget buildCard(String cardType) {
    return GestureDetector(
      onTap: () {
        // Update the selected card type when a card is tapped
        setState(() {
          selectedCardType = cardType;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          // Change the card color based on selection
          color: selectedCardType == cardType
              ? Color.fromARGB(
                  255, 250, 243, 148) // Change to the desired selected color
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              cardType,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
