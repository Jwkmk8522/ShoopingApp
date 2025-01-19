import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/orders.dart' show Orders;
import 'package:shooping_app/Widgets/app_drawer.dart';
import 'package:shooping_app/Widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Screen"),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
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
