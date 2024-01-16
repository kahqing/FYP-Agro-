import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/compare_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCaptureFaceScreen extends StatefulWidget {
  final String id;

  const InfoCaptureFaceScreen({super.key, required this.id});

  @override
  State<InfoCaptureFaceScreen> createState() => _InfoCaptureFaceScreenState();
}

class _InfoCaptureFaceScreenState extends State<InfoCaptureFaceScreen> {
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
                "Let's take a selfie!",
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
                        "Lighting",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Ensure you are in a well-lit area.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Position",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Look straight into the camera.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Accessories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Remove anything that covers your face.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Visibility",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                      Text(
                        "Make sure your face is clearly visible in the frame.",
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
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      VerifyFaceScreen(id: id)));
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
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
