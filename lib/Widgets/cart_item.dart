import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String titlee;
  final int quantity;

  const CartItem({
    super.key,
    required this.price,
    required this.quantity,
    required this.titlee,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Title(
          color: Theme.of(context).colorScheme.error,
          child: Text("$price"),
        ),
        title: Text(titlee),
        subtitle: Text("${price * quantity}"),
        trailing: Text("$quantity x"),
      ),
    );
  }
}
