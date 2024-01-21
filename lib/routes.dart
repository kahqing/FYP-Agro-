import 'package:agro_plus_app/Banking%20Part/Saving%20Goals/Bottom%20Navigation%20Bar/bottom_navi.dart';

import 'package:agro_plus_app/EC%20Part/screens/auction/auction_history.dart';
import 'package:agro_plus_app/EC%20Part/screens/ec_main_screen/ec_main_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/notification/non_winner_notification.dart';
import 'package:agro_plus_app/EC%20Part/screens/notification/winner_notification_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/confirm_payment_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/auction_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/category_listing_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/detail/fixed_price_detail_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_listing/buy_now_listing.dart';
import 'package:agro_plus_app/EC%20Part/screens/product_upload/product_upload_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_menu.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_setting.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signin.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_product_list.dart';
import 'package:agro_plus_app/EC%20Part/screens/seller/seller_signup.dart';
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
  DetailsScreen.routeName: (context) => DetailsScreen(),
  AuctionHistoryScreen.routeName: (context) {
    final matric = ModalRoute.of(context)!.settings.arguments as String;
    return AuctionHistoryScreen(matric: matric);
  },
  WinnerNotificationScreen.routeName: (context) => WinnerNotificationScreen(),
  NonWinnerNotificationScreen.routeName: (context) =>
      NonWinnerNotificationScreen(),
  ConfirmPaymentScreen.routeName: (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final matric = arguments['matric']!;
    final totalPrice = arguments['totalPrice']!;
    return ConfirmPaymentScreen(
      totalPrice: totalPrice,
      matric: matric,
    );
  },
  SignUpScreen.routeName: (context) => SignUpScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SellerSignUpScreen.routeName: (context) => SellerSignUpScreen(),
  SellerSignInScreen.routeName: (context) => SellerSignInScreen(),
  SellerMenuScreen.routeName: (context) {
    final sellerId = ModalRoute.of(context)!.settings.arguments as String;
    return SellerMenuScreen(sellerId: sellerId);
  },
  SellerSettingScreen.routeName: (context) {
    final sellerId = ModalRoute.of(context)!.settings.arguments as String;
    return SellerSettingScreen(sellerId: sellerId);
  },
  SellerProductListScreen.routeName: (context) {
    final sellerId = ModalRoute.of(context)!.settings.arguments as String;
    return SellerProductListScreen(sellerId: sellerId);
  },
  ProductUploadScreen.routeName: (context) {
    final sellerId = ModalRoute.of(context)!.settings.arguments as String;
    return ProductUploadScreen(sellerId: sellerId);
  },
};
