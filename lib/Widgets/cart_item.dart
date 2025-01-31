import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart.dart';
import '../Utilities/show_delete_dialog.dart';

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
    final cart = Provider.of<Cart>(context, listen: false);

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
      confirmDismiss: (direction) {
        return showdeletedialog(
            context,
            "Are you sure you want to Delete this Product From Cart?",
            "Delete");
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(child: Text("${price.toStringAsFixed(2)}")),
            ),
          ),
          title: Text(titlee),
          subtitle: Text("${price * quantity}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  cart.removeSingleItemInDecrement(productId);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "$quantity",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  cart.additems(productId, price, titlee);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
