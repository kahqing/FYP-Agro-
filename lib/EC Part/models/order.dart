import 'package:cloud_firestore/cloud_firestore.dart';

class Order_ {
  final String orderId;
  final String buyerId;
  final String sellerId;
  final String status;

  final double totalPrice;
  final DateTime transactionDate;
  String sellerName;
  List<OrderItem> orderItems;

  Order_({
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    required this.totalPrice,
    required this.status,
    required this.transactionDate,
    required this.sellerName,
    required this.orderItems,
  });

  factory Order_.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp date = data['transactionDate'];

    final List<dynamic> items = data['orderItems'] ?? [];
    final List<OrderItem> orderItems = items.map((item) {
      return OrderItem.fromSnapshot(item);
    }).toList();

    return Order_(
      orderId: doc.id,
      buyerId: data['buyerId'],
      sellerId: data['sellerId'],
      sellerName: data['sellerName'] ?? '',
      totalPrice: data['totalPrice'].toDouble(),
      transactionDate: date.toDate(),
      status: data['status'],
      orderItems: orderItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'totalPrice': totalPrice,
      'transactionDate': transactionDate,
      'status': status,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
    };
  }
}

class OrderItem {
  final String orderId;
  final String productId;
  final String productName;
  final double price;
  final int numOfItems;

  String image;

  OrderItem({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.numOfItems,
    required this.image,
  });

  factory OrderItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final String orderId = doc.reference.parent!.id;

    return OrderItem(
      orderId: orderId,
      productId: data['productId'],
      productName: data['productName'],
      price: data['price'].toDouble(),
      numOfItems: data['numOfItem'],
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'numOfItems': numOfItems,
      'image': image,
    };
  }
}
