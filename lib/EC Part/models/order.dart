import 'package:cloud_firestore/cloud_firestore.dart';

class Order_ {
  final String productId;
  final String productName;
  final int numOfItems;
  final String userId;
  final String status;
  final double totalPrice;
  final DateTime transactionDate;

  Order_({
    required this.productName,
    required this.productId,
    required this.numOfItems,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.transactionDate,
  });

  factory Order_.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    //populate order fields from the data
    return Order_(
      productName: data['productName'],
      productId: data['productId'],
      numOfItems: data['numOfItems'],
      userId: data['userId'],
      status: data['status'],
      totalPrice: data['totalPrice'],
      transactionDate: data['transactionDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productId': productId,
      'numOfItems': numOfItems,
      'userId': userId,
      'status': status,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
    };
  }
}

//to filter the order based on the isDelivered status
// List<Order> filterOrders(List<Order> orders, String isDelivered) {
//   return orders.where((order) => order.status == isDelivered).toList();
// }
