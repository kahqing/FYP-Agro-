import 'package:flutter/widgets.dart';

import 'EC Part/screens/cart/cart_screen.dart';
import 'EC Part/screens/category_listing_screen.dart';
import 'EC Part/screens/detail/detail_screen.dart';
import 'EC Part/screens/ec_main_screen/ec_main_screen.dart';
import 'EC Part/screens/payment/order_confirmation_screen.dart';
import 'EC Part/screens/seller/seller_dashboard_screen.dart';
import 'General Part/sign_in.dart';
import 'General Part/sign_up.dart';

final String username = "";
final Map<String, WidgetBuilder> routes = {
  ECMainScreen.routeName: (context) => ECMainScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CategoryProductsScreen.routeName: (context) => CategoryProductsScreen(),
  SellerDashboard.routeName: (context) {
    final sellerUserId = ModalRoute.of(context)!.settings.arguments as String;
    return SellerDashboard(sellerUserId: sellerUserId);
  },
  // ProductUploadScreen.routeName: (context) {
  //   final sellerUserId = ModalRoute.of(context)!.settings.arguments as String;
  //   return ProductUploadScreen(sellerUserId: sellerUserId);
  // },
  OrderConfirmationScreen.routeName: (context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    return OrderConfirmationScreen(orderId: orderId);
  },
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
