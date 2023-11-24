import 'package:agro_plus_app/EC Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC Part/models/order.dart';
import 'package:agro_plus_app/EC%20Part/screens/order/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static String routeName = '/order_list';

  final String matric;

  OrderScreen({required this.matric});

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 197, 0, 0),
        elevation: 5,
        title: const Text('Order List'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, value, child) {
          orderProvider.loadOrder();
          List<Order_> orders = orderProvider.orders;

          // Use productProvider to access sellerProducts
          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Text('No Order is listed.'),
            );
          }
          orders.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

          //order list
          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: ((context, index) {
              Order_ order = orders[index];

              return ListTile(
                title: Text('OrderID: ${order.orderId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Price: RM ${order.totalPrice}'),
                    Text(
                        'Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(order.transactionDate)}'),
                    Text('Status: ${order.status}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailsScreen(orderId: order.orderId),
                    ),
                  );
                },
              );
            }),
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}
