import 'dart:io';

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shooping_app/Models/http_exceptions.dart';

import '../Providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _item = [
    Product(
      id: 'm1',
      title: "Clothes",
      description: "This is very expensive and good clothes, smooth fabric.",
      price: 675.5,
      imageUrl:
          "https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
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
          "https://images.pexels.com/photos/1682821/pexels-photo-1682821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
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

  Future<void> getAndSetProduct() async {
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      List<Product> loadedProducts = [];

      // print("status code is ${response.statusCode}");
      if (response.statusCode == 200) {
        if (extractedData == null) {
          _item = [];
          notifyListeners();
          throw NoProductsExceptions(
              message: "No products found in the database");
        }
        (extractedData as Map<String, dynamic>).forEach(
          (prodId, prodData) {
            loadedProducts.add(Product(
              id: prodId,
              title: prodData['Title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageurl'],
              isFavourite: prodData['isFavourite'],
            ));
          },
        );
        _item = loadedProducts;
        notifyListeners();
      } else {
        throw HttpExceptions(
            message:
                "Failed to fetch products. Status code: ${response.statusCode}");
      }
    } on SocketException {
      throw NoInternetExceptions(message: "No Internet Connection");
    } catch (error) {
      throw OnUnknownExceptions(message: "An UnExpectedError Occured");
    }
  }

  Future<void> addProducts(
    Product products,
  ) async {
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products.json");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Title': products.title,
          'description': products.description,
          'price': products.price,
          'imageurl': products.imageUrl,
          'isFavourite': products.isFavourite,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: products.title,
        description: products.description,
        price: products.price,
        imageUrl: products.imageUrl,
      );

      _item.add(newProduct);

      // _item.insert(0, products); To add the product at the first, meaning the new product at the top
      notifyListeners();
    } on SocketException {
      NoInternetExceptions(message: "No Inrenet");
    } catch (error) {
      throw OnUnknownExceptions(message: "An UnExpectedError Occured");
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url = Uri.parse(
            "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products/$id.json");

        http.patch(url,
            body: json.encode({
              'Title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageurl': newProduct.imageUrl,
            }));
        _item[prodIndex] = newProduct;
        notifyListeners();
      } else {
        log("----------------------------");
      }
    } on SocketException {
      NoInternetExceptions(message: "No Inrenet");
    } catch (error) {
      throw OnUnknownExceptions(message: "An UnExpectedError Occured");
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products/$id.json");
    final removedProductIndex = _item.indexWhere((prod) => prod.id == id);
    Product? removedProduct = _item[removedProductIndex];
//optimistic updating
    _item.removeAt(removedProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    // print(response.statusCode);

    if (response.statusCode >= 400) {
      _item.insert(removedProductIndex, removedProduct);
      notifyListeners();
      throw HttpExceptions(message: "There is error in response");
    }
    removedProduct = null;
  }
}
