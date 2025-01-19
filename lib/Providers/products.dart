import 'package:flutter/material.dart';

import '../Providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _item = [
    Product(
      id: 'm1',
      title: "Clothes",
      description: "This is very expensive and good clothes, smooth fabric.",
      price: 675.5,
      imageUrl:
          "https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isFavourite: false,
    ),
    Product(
      id: 'm2',
      title: "Shoes",
      description: "Comfortable running shoes for sports.",
      price: 120.0,
      imageUrl:
          "https://images.pexels.com/photos/19090/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isFavourite: false,
    ),
    Product(
      id: 'm3',
      title: "Smartwatch",
      description: "Track your activities and health.",
      price: 199.99,
      imageUrl:
          "https://images.pexels.com/photos/1682821/pexels-photo-1682821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isFavourite: false,
    ),
    Product(
      id: 'm4',
      title: "Laptop",
      description: "High-performance laptop for work and gaming.",
      price: 999.99,
      imageUrl:
          "https://images.pexels.com/photos/18105/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isFavourite: false,
    ),
    Product(
      id: 'm5',
      title: "Headphones",
      description: "Noise-cancelling wireless headphones.",
      price: 299.99,
      imageUrl:
          "https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      isFavourite: false,
    ),
  ];

  List<Product> get item {
    // if (_showFavouritesOnly) {
    //   return _item.where((prodItem) {
    //     return prodItem.isFavourite;
    //   }).toList();
    // }
    return [..._item];
  }

  List<Product> get favouriteItems {
    return _item.where((prodItem) {
      return prodItem.isFavourite;
    }).toList();
  }

  // void showFavouriteOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

//Product Detatil Screen
  Product findById(String productId) {
    return item.firstWhere((prod) {
      return prod.id == productId;
    });
  }
}
