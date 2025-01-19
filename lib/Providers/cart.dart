import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;
  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

// use to delete the item in cart Item class in dismissible widget
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

//use in the cart screen for showing total Amount
  double get totalAmount {
    double total = 0.0;
    _items.forEach(
      (key, CartItem) {
        total += CartItem.price * CartItem.quantity;
      },
    );
    return total;
  }

  // pass count of the product in productoverview class badge widget to value
  int get productCount {
    // 1 case
    //In this case when you press it increse its your choice.
    // return _items.values.fold(0, (sum, item) => sum + item.quantity);
    //2 case
    //_items.length
    //Initially, the cart is empty, so _items.length = 0.
    // You add one product (say, "product A"), _items.length becomes 1.
    // If you add more of the same product A, _items.length will still remain 1 because it's still the same product (same key).
    // If you add a new product (say, "product B"), _items.length becomes 2 because there are now 2 distinct products in the cart.
    return _items.length;
  }

//use add items in cart button which is in ProductItem class
  void additems(String productId, double price, String title) {
    //The containsKey method checks if a specific key exists in a map. It returns a boolean value
    if (_items.containsKey(productId)) {
      //The update method modifies the value associated with an existing key.
      _items.update(
        productId,
        (existingCartItem) {
          return CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1,
            title: existingCartItem.title,
          );
        },
      );
    } else {
      //The putIfAbsent method adds a key-value pair to the map only if the key does not already exist. It takes two arguments: Key anad Funtion
      _items.putIfAbsent(
        productId,
        () {
          return CartItem(
            id: DateTime.now().toString(),
            price: price,
            quantity: 1,
            title: title,
          );
        },
      );
    }

    notifyListeners();
  }

//To clear cart
  void clear() {
    _items = {};
    notifyListeners();
  }
}
