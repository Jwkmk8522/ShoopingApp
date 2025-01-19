import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/cart.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String titlee;
  final int quantity;
  final String productId;
  final String id;

  const CartItem({
    super.key,
    required this.price,
    required this.quantity,
    required this.titlee,
    required this.id,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onError,
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.delete,
          size: 32,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(child: Text("$price")),
            ),
          ),
          title: Text(titlee),
          subtitle: Text("${price * quantity}"),
          trailing: Text(
            "$quantity x",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
