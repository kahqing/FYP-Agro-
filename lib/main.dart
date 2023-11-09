import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:agro_plus_app/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final cartProvider = CartProvider(userId: userId);
  // cartProvider.loadCartData();
  // print('loadCartData function is called');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider(matric: '')),
        ChangeNotifierProvider(create: (_) => ProductProvider(matric: '')),
        ChangeNotifierProvider(create: (_) => OrderProvider(matric: '')),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro+',
      routes: routes,
      home: SignInScreen(),
    );
  }
}
