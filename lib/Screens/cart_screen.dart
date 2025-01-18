import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/cart.dart' show Cart;
import 'package:shooping_app/Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart "),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text("\$${cart.totalAmount}"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Order Now",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItem(
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  titlee: cart.items.values.toList()[index].title,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
