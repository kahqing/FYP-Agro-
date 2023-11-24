import 'package:agro_plus_app/Banking%20Part/Open%20Bank%20Account/Verification%20Part/info_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessVerifyScreen extends StatefulWidget {
  final String id;
  const SuccessVerifyScreen({super.key, required this.id});

  @override
  State<SuccessVerifyScreen> createState() => _SuccessVerifyScreenState();
}

class _SuccessVerifyScreenState extends State<SuccessVerifyScreen> {
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
              Text("Verified Successful!!!!"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StepsInfoScreen(id: id)));
                  },
                  child: Text("Finish"))
            ],
          ),
        ),
      ),
    );
  }
}
