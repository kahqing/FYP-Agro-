import 'package:agro_plus_app/EC%20Part/models/cartItem.dart';
import 'package:agro_plus_app/EC%20Part/provider/cart_provider.dart';
import 'package:agro_plus_app/EC%20Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/checkout_screen_content.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/order_confirmation_screen.dart';
import 'package:agro_plus_app/EC%20Part/screens/payment/payment_service.dart';
import 'package:agro_plus_app/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  static String routeName = '/checkout';

  final String matric;
  final List<CartItem> cartItem;
  final double subtotal;

  const CheckoutScreen({
    required this.matric,
    required this.cartItem,
    required this.subtotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  String apiUrl = AppConfig.apiHostname;

  @override
  void initState() {
    super.initState();
    cartProvider = CartProvider(matric: widget.matric);
    orderProvider = OrderProvider(matric: widget.matric);
  }

  String userAddress = '';
  String userName = '';
  String contactNum = '';

  double totalPrice = 0;
  Map<String, List<CartItem>> groupedCartItems = {};
  List<SellerGroup> sellerGroups = [];

  void groupCartItems(List<CartItem> cartItems) {
    for (var item in cartItems) {
      //if the list has no seller id as key
      if (!groupedCartItems.containsKey(item.sellerId)) {
        //initialise the list when key is not present
        groupedCartItems[item.sellerId] = [];
      }
      //add the item into the list
      groupedCartItems[item.sellerId]!.add(item);
    }
    print('groupedCartItems: $groupedCartItems');

    groupedCartItems.forEach((sellerId, items) {
      //create SellerGroup instance
      SellerGroup sellerGroup = SellerGroup(
          sellerId: sellerId,
          sellerName: '',
          tax: 0.0,
          deliveryFee: 0.0,
          taxAmount: 0.0,
          subtotal: 0.0,
          total: 0.0,
          cartItems: items);

      sellerGroups.add(sellerGroup);
    });
  }

  Future<bool> fetchData() async {
    try {
      //fetch buyer data: name, address abd phone
      await fetchBuyerData();

      //arrange the cart items based on the seller id
      print('widget.cartItem: ${widget.cartItem}');
      groupCartItems(widget.cartItem);

      //fetch seller data: seller name, tax and delivery fee
      await fetchSellerData();

      //calculate the subtotal, tax and delivery fee based on seller id
      calculateFees();

      //calculate total price
      return true;
    } catch (error) {
      print('Error fetching data: $error');
      return false;
    }
  }

  Future<void> fetchBuyerData() async {
    try {
      //fetch document snapshot
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.matric)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        userName = userData['username'];
        userAddress = userData['address'];
        contactNum = userData['phone'];

        print('userData is loaded: $userName  $userAddress  $contactNum');
      } else {
        print('User document not found');
      }
    } catch (error) {
      print('Error fetching buyer data: $error');
    }
  }

  Future<void> fetchSellerData() async {
    try {
      for (var sellerGroup in sellerGroups) {
        print('sellerId in fetch seller data: ${sellerGroup.sellerId}');
        //fetch document snapshot
        DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
            .collection('seller')
            .doc(sellerGroup.sellerId)
            .get();

        if (sellerSnapshot.exists) {
          Map<String, dynamic> sellerData =
              sellerSnapshot.data() as Map<String, dynamic>;

          sellerGroup.sellerName = sellerData['sellerName'];
          sellerGroup.tax = sellerData['tax']?.toDouble() ?? 0;
          sellerGroup.deliveryFee = sellerData['deliveryFee']?.toDouble() ?? 0;

          print(
              'Seller data is loaded: ${sellerGroup.sellerName}  ${sellerGroup.tax} ${sellerGroup.deliveryFee}');
        } else {
          print('Seller document not found');
        }
      }
    } catch (error) {
      print('Error fetching seller data: $error');
    }
  }

  void calculateFees() {
    for (var sellerGroup in sellerGroups) {
      double sellerSubtotal = 0;

      for (var item in sellerGroup.cartItems) {
        //calculate the subtotal for items of the same seller
        sellerSubtotal += item.price * item.numOfItem;
      }
      double taxAmount = sellerSubtotal * ((sellerGroup.tax) / 100);

      //update seller group with calculated value
      sellerGroup.subtotal = sellerSubtotal;
      sellerGroup.taxAmount = taxAmount;
      sellerGroup.total = sellerGroup.subtotal +
          sellerGroup.taxAmount +
          sellerGroup.deliveryFee;
    }
    print(sellerGroups);
  }

  // Method to calculate overall total price needed to pay
  double calculateTotalPrice() {
    double total = 0;

    for (var sellerGroup in sellerGroups) {
      total += sellerGroup.subtotal +
          sellerGroup.taxAmount +
          sellerGroup.deliveryFee;
    }
    totalPrice = total;

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data == true) {
          return CheckOutScreenContent(
              userAddress: userAddress,
              matric: widget.matric,
              userName: userName,
              contactNum: contactNum,
              totalPrice: calculateTotalPrice(),
              sellerGroupData: sellerGroups,
              onMakePaymentPressed: () async {
                PaymentService paymentService = PaymentService();
                await paymentService.initiatePayment(context, widget.matric,
                    sellerGroups, widget.cartItem, orderProvider, totalPrice);
              });
        } else {
          return const Text('Failed to fetch data');
        }
      },
    );
  }
}

// SellerGroup class to hold seller-specific information
class SellerGroup {
  final String sellerId;
  String sellerName;
  double tax;
  double deliveryFee;
  double taxAmount;
  double subtotal;
  double total;
  final List<CartItem> cartItems;

  // Initialize the variables inside the constructor
  SellerGroup({
    required this.sellerId,
    this.sellerName = '',
    this.tax = 0.0,
    this.deliveryFee = 0.0,
    this.taxAmount = 0.0,
    this.subtotal = 0.0,
    this.total = 0.0,
    required this.cartItems,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'total': total,
    };
  }
}
