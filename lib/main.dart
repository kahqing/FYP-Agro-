import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/product_provider.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String userId = '206067';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final cartProvider = CartProvider(userId: userId);
  cartProvider.loadCartData();
  print('loadCartData function is called');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider(userId: userId)),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
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
    return const MaterialApp(
      title: 'Agro+',
      home: SignInScreen(),
    );
  }
}
