import 'dart:convert';

import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:agro_plus_app/routes.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //get FCM token for the device
  // final _firebaseMessaging = FirebaseMessaging.instance;
  // await FirebaseMessaging.instance.requestPermission();
  // final fcmToken = await _firebaseMessaging.getToken();
  // print('FCM Token: $fcmToken');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FCM Message Received: ${message.notification?.body}");

    // show notification as flashbar with onTap for navigation
    Flushbar(
      title: "Won an Auction!",
      message: "${message.notification?.body}",
      onTap: (_) {
        // Implement navigation logic here
        print("User tapped on the notification. Navigate to the desired page.");
        Navigator.pushNamed(
            navigatorKey.currentState!.context, '/notification_screen',
            arguments: {"message": json.encode(message.data)});
      },
      duration: const Duration(seconds: 5),
    ).show(navigatorKey.currentState!.context);
  });

  //If app was terminated and now opened
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(
          navigatorKey.currentState!.context, '/notification_screen',
          arguments: {"message": json.encode(message.data)});
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //if app is at background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('onMessageOpenedApp: ${message.notification?.body}');
    Navigator.pushNamed(
        navigatorKey.currentState!.context, '/notification_screen',
        arguments: {"message": json.encode(message.data)});
  });

  // Create instances of CartProvider and ProductProvider
  CartProvider cartProvider = CartProvider(matric: '');
  ProductProvider productProvider = ProductProvider(matric: '');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartProvider),
        ChangeNotifierProvider(create: (_) => productProvider),
        ChangeNotifierProvider(create: (_) => OrderProvider(matric: '')),
      ],
      child: MyApp(),
    ),
  );
}

void showNotification(String title, String body, RemoteMessage message) {
  print('Showing notification: Title - $title, Body - $body');
  // show notification as flashbar with onTap for navigation
  Flushbar(
    title: "New Notification",
    message: title,
    onTap: (_) {
      // Implement navigation logic here
      print("User tapped on the notification. Navigate to the desired page.");
      Navigator.pushNamed(
          navigatorKey.currentState!.context, '/notification_screen',
          arguments: {"message": json.encode(message.data)});
    },
    duration: Duration(seconds: 3),
  ).show(navigatorKey.currentState!.context);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("_firebaseMEssagingBackgrounfHandler: $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro+',
      navigatorKey: navigatorKey,
      routes: routes,
      home: SignInScreen(),
    );
  }
}
