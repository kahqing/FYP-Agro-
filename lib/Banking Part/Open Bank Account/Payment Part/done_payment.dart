import 'package:agro_plus_app/General%20Part/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DonePaymentScreen extends StatefulWidget {
  final String id;
  const DonePaymentScreen({super.key, required this.id});

  @override
  State<DonePaymentScreen> createState() => _DonePaymentScreenState();
}

class _DonePaymentScreenState extends State<DonePaymentScreen> {
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
              Text("Done Payment!!!!"),
              Text("Successful created your Agrobank account!!!!"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomepageScreen(matric: id)));
                  },
                  child: Text("Finish"))
            ],
          ),
        ),
      ),
    );
  }
}
