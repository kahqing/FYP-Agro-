import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/capture_ic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CaptureICInfoScreen extends StatefulWidget {
  final String id;
  const CaptureICInfoScreen({super.key, required this.id});

  @override
  State<CaptureICInfoScreen> createState() => _CaptureICInfoScreenState();
}

class _CaptureICInfoScreenState extends State<CaptureICInfoScreen> {
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
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
                  Color.fromARGB(255, 229, 48, 48),
                  Color.fromARGB(255, 127, 18, 18)
                ])),
            child: const Center(
              child: Text(
                "Let's capture your MyKad!",
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Before that, ensure you have:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Good Lighting",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Ensure you are in a well-lit area. Natural daylight or good indoor lighting helps capture clear images.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "No Dark Shadows",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Try to avoid shadows on your MyKad. It helps if the light is not too bright or too dark.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Even Light",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Try to have the light spread evenly on your MyKad. This helps get a clear picture of all the details.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 160, 24, 14)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      CaptureICScreen(id: id)));
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
