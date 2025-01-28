import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  String imageUrl;
  bool isFavourite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toogleFavouriteStatus(String? token) async {
    final olddStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    var url = Uri.parse(
        "https://shoopingapp-12774-default-rtdb.firebaseio.com/Products/$id.json?auth=$token");

    try {
      final response = await http.patch(url,
          body: json.encode({
            "isFavourite": isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = olddStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = olddStatus;
      notifyListeners();
    }
  }
}
