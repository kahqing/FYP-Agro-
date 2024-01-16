import 'package:cloud_firestore/cloud_firestore.dart';

class Order_ {
  final String orderId;
  final String customerId;
  final String status;
  final double totalPrice;
  final DateTime transactionDate;
  final List<OrderItem> orderItems;

  Order_({
    //required this.numOfItems,
    required this.orderId,
    required this.customerId,
    required this.status,
    required this.totalPrice,
    required this.transactionDate,
    required this.orderItems,
  });

  factory Order_.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp date = data['transactionDate'];

    final List<dynamic> items = data['orderItems'] ?? [];
    final List<OrderItem> orderItems = items.map((item) {
      return OrderItem(
        productId: item['productId'],
        productName: item['productName'],
        price: item['price'],
        numOfItem: item['numOfItems'],
      );
    }).toList();
    //populate order fields from the data
    return Order_(
      // productName: data['productName'],
      // productId: data['productId'],
      // numOfItems: data['numOfItems'],
      orderId: doc.id,
      customerId: data['customerId'],
      status: data['status'],
      totalPrice: data['totalPrice'],
      transactionDate: date.toDate(),
      orderItems: orderItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'productName': productName,
      // 'productId': productId,
      // 'numOfItems': numOfItems,
      'orderId': orderId,
      'customerId': customerId,
      'status': status,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int numOfItem;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.numOfItem,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'numOfItem': numOfItem,
    };
  }
}

//to filter the order based on the isDelivered status
// List<Order> filterOrders(List<Order> orders, String isDelivered) {
//   return orders.where((order) => order.status == isDelivered).toList();
// }
