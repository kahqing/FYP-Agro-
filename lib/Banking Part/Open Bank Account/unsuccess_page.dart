import 'package:flutter/material.dart';

class UnsuccessScreen extends StatefulWidget {
  const UnsuccessScreen({super.key});

  @override
  State<UnsuccessScreen> createState() => _UnsuccessScreenState();
}

class _UnsuccessScreenState extends State<UnsuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text("Nooooo, Unsuccessful!!!!"),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             HomepageScreen(matric: matric)));
                },
                child: Text("Finish"))
          ],
        ),
      ),
    );
  }
}
