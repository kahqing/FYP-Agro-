import 'package:agro_plus_app/EC%20Part/screens/auction/auction_history.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/notification/notification_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/auction_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/category_listing_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/detail/detail_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/buy_now_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_dashboard_screen.dart';
import 'package:agro_plus_app/General%20Part/sign_in.dart';
import 'package:agro_plus_app/General%20Part/sign_up.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  ECMainScreen.routeName: (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final matric = arguments['matric']!;
    return ECMainScreen(matric: matric);
  },
  AuctionProductsScreen.routeName: (context) => AuctionProductsScreen(),
  BuyNowProductsScreen.routeName: (context) => BuyNowProductsScreen(),
  CategoryProductsScreen.routeName: (context) => CategoryProductsScreen(),
  SellerDashboard.routeName: (context) {
    final sellerUserId = ModalRoute.of(context)!.settings.arguments as String;
    return SellerDashboard(sellerUserId: sellerUserId);
  },
  DetailsScreen.routeName: (context) => DetailsScreen(),
  AuctionHistoryScreen.routeName: (context) => AuctionHistoryScreen(),
  NotificationScreen.routeName: (context) => NotificationScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
