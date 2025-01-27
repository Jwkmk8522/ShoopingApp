import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/orders.dart' show Orders;
import '../Widgets/app_drawer.dart';
import '../Widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    _isLoading = true;

    Provider.of<Orders>(context, listen: false).getAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Screen"),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                return OrderItem(
                  order: order.items[index],
                );
              },
            ),
    );
  }
}
