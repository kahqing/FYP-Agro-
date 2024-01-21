import 'package:agro_plus_app/EC Part/provider/order_provider.dart';
import 'package:agro_plus_app/EC Part/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SellerOrderScreen extends StatefulWidget {
  static String routeName = '/seller_order_list';

  final String sellerId;

  SellerOrderScreen({required this.sellerId});

  @override
  State<SellerOrderScreen> createState() => _SellerOrderScreenState();
}

class _SellerOrderScreenState extends State<SellerOrderScreen> {
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
          backgroundColor: const Color.fromARGB(255, 40, 19, 96),
          elevation: 5,
          title: const Text(
            'Seller Order List',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 17),
            unselectedLabelColor: Color.fromARGB(255, 173, 199, 252),
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
          color: const Color.fromARGB(255, 205, 212, 246),
          child: Consumer<OrderProvider>(
            builder: (context, value, child) {
              orderProvider.loadSellerOrders(widget.sellerId);
              List<Order_> orders = orderProvider.orders;
              //print(orders);

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
    //filter orders based on status
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
              color: const Color.fromARGB(255, 237, 230, 230),
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
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(
                      'Status: ${order.status}',
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
                              style: const TextStyle(fontSize: 17),
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
                  margin: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: order.status == 'Prepared'
                      ? ElevatedButton(
                          onPressed: () async {
                            // Assuming you have a method like updateOrderStatus
                            await orderProvider.updateOrderStatus(
                                order.orderId, 'Delivered');
                            // Reload orders after updating status
                            orderProvider.loadSellerOrders(widget.sellerId);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 197, 0, 0)),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                    color: Color.fromARGB(255, 197, 0, 0)),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Delivered',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        });
  }
}
