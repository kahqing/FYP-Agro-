import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationHandler {
  // notification for when app is at foreground
  static void handleOnMessage(RemoteMessage message, BuildContext context) {
    print("handleOnMessage: ${message.notification?.body}");

    String notificationType = message.data['notiType'];

    if (notificationType == 'winner') {
      print("Received winner notification");

      // show notification as flashbar with onTap for navigation
      Flushbar(
        title: "${message.notification?.title}",
        message: "${message.notification?.body}",
        onTap: (_) {
          // Implement navigation logic here
          print(
              "User tapped on non-winner notification. Navigate to the non-winner noti screen.");
          Navigator.pushNamed(context, '/winner_notification_screen',
              arguments: {"message": json.encode(message.data)});
        },
        duration: const Duration(seconds: 5),
      ).show(context);
    } else if (notificationType == 'nonWinner') {
      print("Received non-winner notification");
      Flushbar(
        title: "${message.notification?.title}",
        message: "${message.notification?.body}",
        onTap: (_) {
          // Implement navigation logic here
          print(
              "Receive non-winner notification. Navigate to the non-winner noti screen.");
          Navigator.pushNamed(context, '/non_winner_notification_screen',
              arguments: {"message": json.encode(message.data)});
        },
        duration: const Duration(seconds: 5),
      ).show(context);
    }
  }

  // notification for when app is at background or terminated

  static void handlePushNotification(
      RemoteMessage message, BuildContext context) {
    String notificationType = message.data['notiType'];

    if (notificationType == 'winner') {
      print("Received winner notification");
      Navigator.pushNamed(context, '/winner_notification_screen',
          arguments: {"message": json.encode(message.data)});
    } else if (notificationType == 'nonWinner') {
      print("Received non-winner notification");

      Navigator.pushNamed(context, '/non_winner_notification_screen',
          arguments: {"message": json.encode(message.data)});
    }
  }
}
