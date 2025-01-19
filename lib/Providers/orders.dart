import 'package:flutter/material.dart';
import 'package:shooping_app/Providers/cart.dart';

class OrderItem {
  final String id;
  final DateTime date;
  final List<CartItem> products;
  final double amount;
  OrderItem({
    required this.amount,
    required this.date,
    required this.id,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _items = [];
  List<OrderItem> get items {
    return [..._items];
  }

  void addOrder(List<CartItem> cartProducts, double amount) {
    _items.insert(
        0,
        OrderItem(
            amount: amount,
            date: DateTime.now(),
            id: DateTime.now().toString(),
            products: cartProducts));
  }
}
