import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shooping_app/Providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "${widget.order.amount.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(
                DateTime.now(),
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: _expanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(
                      Icons.expand_more,
                      size: 26,
                    ),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                  children: widget.order.products.map(
                (val) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        val.title,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${val.quantity} x ${val.price}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                },
              ).toList()),
            ),
        ],
      ),
    );
  }
}
