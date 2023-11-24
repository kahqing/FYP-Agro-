import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:agro_plus_app/EC%20Part/models/order.dart';
import 'package:agro_plus_app/EC%20Part/models/order_repository.dart'; // Import the OrderRepository

class OrderDetailsScreen extends StatefulWidget {
  static String routeName = '/order_details';
  final String orderId;

  OrderDetailsScreen({required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Order_> _orderFuture;
  final OrderRepository _orderRepository = OrderRepository();

  @override
  void initState() {
    super.initState();
    _orderFuture = _orderRepository.getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<Order_>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Order not found'));
          } else {
            Order_ order = snapshot.data!;
            return buildOrderDetails(order);
          }
        },
      ),
    );
  }

  Widget buildOrderDetails(Order_ order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: ${order.orderId}'),
          const SizedBox(height: 16),
          Text(
            'Transaction Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(order.transactionDate)}',
          ),
          const SizedBox(height: 16),
          Text('Total Price: RM ${order.totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Text('Order Items:'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.orderItems.map((item) {
              return ListTile(
                title: Text(item.productName),
                subtitle: Text('Price: RM${item.price.toStringAsFixed(2)}'),
              );
            }).toList(),
          ),
          const Spacer(),
          order.status != 'Received'
              ? ElevatedButton(
                  onPressed: () async {
                    await _orderRepository.updateOrderStatus(
                        order.orderId, 'Received');
                    //navigate back to the OrderScreen
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 197, 0, 0),
                      elevation: 3,
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: const Text(
                    'Receive',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
