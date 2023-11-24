import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/compare_face.dart';
import 'package:flutter/material.dart';

class FailedVerifiedScreen extends StatefulWidget {
  final String id;
  const FailedVerifiedScreen({super.key, required this.id});

  @override
  State<FailedVerifiedScreen> createState() => _FailedVerifiedScreenState();
}

class _FailedVerifiedScreenState extends State<FailedVerifiedScreen> {
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              Text("Noooo, Failed to Verify!!!!"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyFaceScreen(id: id)));
                  },
                  child: Text("Finish"))
            ],
          ),
        ),
      ),
    );
  }
}
