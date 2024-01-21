import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessWithdrawScreen extends StatefulWidget {
  const SuccessWithdrawScreen({super.key});

  @override
  State<SuccessWithdrawScreen> createState() => _SuccessWithdrawScreenState();
}

class _SuccessWithdrawScreenState extends State<SuccessWithdrawScreen> {
  int countdown = 3; // Initial countdown value
  late Timer timer;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startCountdown();
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

          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 247, 222),
        height: double.infinity,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset("assets/animation_withdraw.json",
                    fit: BoxFit.cover),
              ),
              const SizedBox(height: 80),
              const Text(
                "Withdraw Successfully!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const Text("Your money is transfer to your account.",
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
                    "Back",
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
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
