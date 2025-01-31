import 'dart:io';

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shooping_app/Models/http_exceptions.dart';

import '../Providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _item = [
    // Product(
    //   id: 'm1',
    //   title: "Clothes",
    //   description: "This is very expensive and good clothes, smooth fabric.",
    //   price: 675.5,
    //   imageUrl:
    //       "https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'm2',
    //   title: "Shoes",
    //   description: "Comfortable running shoes for sports.",
    //   price: 120.0,
    //   imageUrl:
    //       "https://images.pexels.com/photos/19090/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'm3',
    //   title: "Smartwatch",
    //   description: "Track your activities and health.",
    //   price: 199.99,
    //   imageUrl:
    //       "https://images.pexels.com/photos/1682821/pexels-photo-1682821.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'm4',
    //   title: "Laptop",
    //   description: "High-performance laptop for work and gaming.",
    //   price: 999.99,
    //   imageUrl:
    //       "https://images.pexels.com/photos/18105/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'm5',
    //   title: "Headphones",
    //   description: "Noise-cancelling wireless headphones.",
    //   price: 299.99,
    //   imageUrl:
    //       "https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1.png",
    //   isFavourite: false,
    // ),
  ];

  String? authToken;
  String? userId;

  Products(this.authToken, this._item, this.userId);
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

  Future<void> getAndSetProduct([bool filterByUser = false]) async {
    // var url = Uri.parse(
    //     'https://shoopingapp-12774-default-rtdb.firebaseio.com/Products.json?auth=$authToken$orderBy="createrId"$equalTo="$userId"');
    String filterString =
        filterByUser ? 'orderBy=%22createrId%22&equalTo=%22$userId%22' : '';
    var url = Uri.parse(
        'https://shoopingapp-12774-default-rtdb.firebaseio.com/Products.json?auth=$authToken&$filterString');

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
        var url = Uri.parse(
            "https://shoopingapp-12774-default-rtdb.firebaseio.com/UserFavourite/$userId.json/?auth=$authToken");
        final favouriteResponse = await http.get(url);
        final extractedFavourite = json.decode(favouriteResponse.body);
        // print(response.body);
        // print(favouriteResponse.body);

        (extractedData as Map<String, dynamic>).forEach(
          (prodId, prodData) {
            loadedProducts.add(Product(
                id: prodId,
                title: prodData['Title'],
                description: prodData['description'],
                price: prodData['price'],
                imageUrl: prodData['imageurl'],
                isFavourite: extractedFavourite == null
                    ? false
                    : extractedFavourite[prodId] ?? false));
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
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products.json?auth=$authToken");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Title': products.title,
          'description': products.description,
          'price': products.price,
          'imageurl': products.imageUrl,
          'createrId': userId,
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
    } on SocketException {
      throw NoInternetExceptions(message: "No Inrenet");
    } catch (error) {
      throw OnUnknownExceptions(message: "An UnExpectedError Occured");
    }
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url = Uri.parse(
            "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products/$id.json?auth=$authToken");

        await http.patch(url,
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
      throw NoInternetExceptions(message: "No Inrenet");
    } catch (error) {
      throw OnUnknownExceptions(message: "An UnExpectedError Occured");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products/$id.json?auth=$authToken");

    final removedProductIndex = _item.indexWhere((prod) => prod.id == id);
    if (removedProductIndex < 0) return;

    Product removedProduct = _item[removedProductIndex];

    _item.removeAt(removedProductIndex);
    notifyListeners(); // ✅ Optimistic update (remove item before confirming success)

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        throw HttpExceptions(message: "Failed to delete product from server.");
      }
    } on SocketException {
      // ✅ Handle no internet connection
      _item.insert(
          removedProductIndex, removedProduct); // Restore product in UI
      notifyListeners();
      throw HttpExceptions(
          message: "No Internet Connection. Product not deleted.");
    } catch (error) {
      _item.insert(
          removedProductIndex, removedProduct); // Restore product in UI
      notifyListeners();
      throw HttpExceptions(message: "Something went wrong.");
    }
  }
}
