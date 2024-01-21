import 'dart:async';

import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Goal%20Details/goal_details.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CongratCompletedGoalScreen extends StatefulWidget {
  final String id;
  final String category;
  final String title;
  const CongratCompletedGoalScreen(
      {super.key,
      required this.id,
      required this.category,
      required this.title});

  @override
  State<CongratCompletedGoalScreen> createState() =>
      _CongratCompletedGoalScreenState();
}

class _CongratCompletedGoalScreenState
    extends State<CongratCompletedGoalScreen> {
  int countdown = 5; // Initial countdown value
  late Timer timer;
  late ConfettiController _controller;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startCountdown();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();
    player.play(AssetSource('congratSound.mp3'));
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          // When the countdown reaches 0, navigate to the next screen
          timer.cancel();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetailsScreen(
                  id: widget.id,
                  category: widget.category,
                  title: widget.title),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color.fromARGB(255, 255, 243, 222),
                  Color.fromARGB(255, 255, 227, 249)
                ])),
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    // decoration: BoxDecoration(
                    //     color: const Color.fromARGB(255, 134, 27, 27),
                    //     borderRadius: BorderRadius.circular(100)
                    //     //more than 50% of width makes circle
                    //     ),
                    child: Icon(
                      Icons.celebration_rounded,
                      color: Color.fromARGB(255, 125, 9, 9),
                      size: 150,
                    ).animate().then().shake(duration: 250.ms),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Congratulation!",
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ).animate().then().shake(),
                  const SizedBox(height: 30),
                  const Text(
                    "You complete this goal.",
                    style: TextStyle(
                        fontSize: 17, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 160, 24, 14),
                      ),
                      onPressed: () {
                        timer
                            .cancel(); // Cancel the timer when the button is pressed
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Redirect you to previous page after $countdown seconds", // Display the countdown
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ConfettiWidget(
                  confettiController: _controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: [
                    Color.fromARGB(255, 218, 64, 64),
                    Color.fromARGB(255, 234, 117, 255),
                    Color.fromARGB(255, 248, 186, 31),
                    Color.fromARGB(255, 17, 248, 240),
                    Color.fromARGB(255, 20, 245, 50)
                  ],
                  // colors: [
                  //   Colors.yellow,
                  //   Colors.pink,
                  //   Colors.orange,
                  //   Colors.purple,
                  //   Color.fromARGB(255, 138, 27, 27)
                  // ],
                  shouldLoop: false,
                  numberOfParticles: 20,
                  gravity: 0.3,
                  emissionFrequency: 0.03,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
