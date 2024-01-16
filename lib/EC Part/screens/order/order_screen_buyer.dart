import 'package:agro_plus_app/EC Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC Part/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static String routeName = '/buyer_order_list';

  final String matric;

  OrderScreen({required this.matric});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: true);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: const Color.fromARGB(255, 197, 0, 0),
          elevation: 5,
          title: const Text(
            'Buyer Order List',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 17),
            unselectedLabelColor: Color.fromARGB(255, 254, 181, 157),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(text: 'Prepared'),
              Tab(text: 'Delivered'),
              Tab(text: 'Completed'),
              Tab(text: 'Refund'),
            ],
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 255, 226, 226),
          child: Consumer<OrderProvider>(
            builder: (context, value, child) {
              orderProvider.loadBuyerOrders(widget.matric);
              List<Order_> orders = orderProvider.orders;
              //print('body :$orders');

              if (orderProvider.orders.isEmpty) {
                return const Center(
                  child: Text('No orders yet'),
                );
              }
              orders.sort(
                  (a, b) => b.transactionDate.compareTo(a.transactionDate));

              return TabBarView(
                children: [
                  _buildOrderList(orders, 'Prepared'),
                  _buildOrderList(orders, 'Delivered'),
                  _buildOrderList(orders, 'Completed'),
                  _buildOrderList(orders, 'Refund'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order_> orders, String status) {
    // Filter orders based on status
    final filteredOrders =
        orders.where((order) => order.status == status).toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text('No orders yet'),
      );
    }

    return ListView.builder(
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          Order_ order = filteredOrders[index];
          OrderProvider orderProvider =
              Provider.of<OrderProvider>(context, listen: false);

          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey, // Shadow color
                  offset: Offset(0, 2), // Horizontal and vertical offset
                  blurRadius: 6, // Spread of the shadow
                  spreadRadius: 0, // Extend the shadow in all directions
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Status: ${order.status}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Seller: ${order.sellerName}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Transaction Date: ${DateFormat('yyyy-MM-dd HH:mm a').format(order.transactionDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ...order.orderItems.map(
                  (orderItem) => Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: 10,
                          height: 100,
                          child: Image.network(
                            orderItem.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderItem.productName,
                              style: const TextStyle(fontSize: 18),
                            ),

                            Text(
                                'Price: RM ${orderItem.price.toStringAsFixed(2)}'),
                            Text('Qty: ${orderItem.numOfItems}'),
                            // Add more details as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: order.status == 'Delivered'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await orderProvider.updateOrderStatus(
                                      order.orderId, 'Refund');
                                  orderProvider.loadBuyerOrders(widget.matric);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                          color:
                                              Color.fromARGB(255, 197, 0, 0)),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Refund',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 197, 0, 0)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  print(
                                      "orderId: ${order.orderId} status: ${order.status}");
                                  await orderProvider.updateOrderStatus(
                                      order.orderId, 'Completed');
                                  orderProvider.loadBuyerOrders(widget.matric);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 197, 0, 0)),
                                  shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                          color:
                                              Color.fromARGB(255, 197, 0, 0)),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Receive',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        });
  }
}
