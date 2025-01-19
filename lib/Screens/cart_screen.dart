import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/cart.dart' show Cart;
import 'package:shooping_app/Providers/orders.dart';

import 'package:shooping_app/Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Your Cart "),
            Text(
              " Total Items ${cart.items.length}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 1,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: const EdgeInsets.all(10),
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: const Text(
                        "Order Now",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
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
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
