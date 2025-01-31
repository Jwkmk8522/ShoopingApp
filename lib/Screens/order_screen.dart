import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';

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

  Future<void> _getOrder() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Orders>(context, listen: false).getAndSetOrders();
    } on NoInternetExceptions catch (error) {
      showErrorDialog(context, error.message);
    } on OnUnknownExceptions catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, 'Some thing went wrong');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getOrder();

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
          :
          //  order.items.isEmpty
          //     ? const Center(
          //         child: Text(
          //             "No Orders Yet. Add items to your cart!"), // Message for no orders
          //       )
          //     :
          ListView.builder(
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
