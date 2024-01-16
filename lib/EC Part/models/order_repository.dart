// import 'package:agro_plus_app/EC%20Part/models/order.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderRepository {
//   final CollectionReference ordersCollection =
//       FirebaseFirestore.instance.collection('orders');

//   Future<void> updateOrderStatus(String orderId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(orderId)
//           .update({'status': newStatus});
//     } catch (e) {
//       throw Exception('Failed to update order status: $e');
//     }
//   }

//   Future<Order_> getOrderDetails(String orderId) async {
//     DocumentSnapshot orderSnapshot = await ordersCollection.doc(orderId).get();

//     if (orderSnapshot.exists) {
//       final data = orderSnapshot.data() as Map<String, dynamic>;
//       final Timestamp date = data['transactionDate'];

//       QuerySnapshot orderItemsSnapshot =
//           await ordersCollection.doc(orderId).collection('orderItems').get();

//       final List<OrderItem> orderItems = orderItemsSnapshot.docs.map((item) {
//         Map<String, dynamic> itemData = item.data() as Map<String, dynamic>;
//         return OrderItem(
//             productId: itemData['productId'],
//             productName: itemData['productName'],
//             price: double.parse(itemData['price'].toString()),
//             numOfItems: itemData['numOfItems'],
//             status: itemData['status'],
//             sellerId: itemData['sellerId']);
//       }).toList();

//       return Order_(
//           orderId: orderSnapshot.id,
//           customerId: data['customerId'],
//           totalPrice: data['totalPrice'].toDouble(),
//           transactionDate: date.toDate(),
//           orderItems: orderItems);
//     } else {
//       throw Exception('Order not found');
//     }
//   }
// }
