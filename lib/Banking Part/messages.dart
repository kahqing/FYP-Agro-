import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class StatusMessage {
  void showSuccessMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 4,
        backgroundColor: Color.fromARGB(255, 103, 255, 108),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        fontSize: 15.0);
  }

  void showUnsuccessMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 4,
        backgroundColor: Color.fromARGB(255, 186, 1, 1),
        textColor: Color.fromARGB(255, 255, 255, 255),
        fontSize: 15.0);
  }
}
