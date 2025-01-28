import 'package:flutter/material.dart';

import '../Providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<OrderItem> _items = [];
  List<OrderItem> get items {
    return [..._items];
  }

  final String? token;
  Orders(this.token, this._items);
  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Orders.json?auth=$token");
    final date = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'date': date.toIso8601String(),
          'amount': amount,
          'products': cartProducts
              .map((pro) => {
                    'id': pro.id,
                    'price': pro.price,
                    'quantity': pro.quantity,
                    'title': pro.title,
                  })
              .toList(),
        },
      ),
    );
    _items.insert(
        0,
        OrderItem(
            amount: amount,
            date: date,
            id: json.decode(response.body)['name'],
            products: cartProducts));
  }

  Future<void> getAndSetOrders() async {
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Orders.json?auth=$token");
    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body);

    if (extractedData == null) {
      // If the data is null, clear the list and notify listeners
      _items = [];
      notifyListeners();
      return;
    }

    // Ensure extractedData is treated as a Map<String, dynamic>
    (extractedData as Map<String, dynamic>).forEach(
      (orderId, orderData) {
        List<CartItem> products = [];

        for (var item in orderData['products']) {
          products.add(
            CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            ),
          );
        }

        loadedOrders.add(
          OrderItem(
            amount: orderData['amount'],
            date: DateTime.parse(orderData['date']),
            id: orderId,
            products: products,
          ),
        );
      },
    );

    _items = loadedOrders;
    notifyListeners();
  }
}
