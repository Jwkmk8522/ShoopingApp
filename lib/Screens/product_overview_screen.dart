import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shooping_app/Enums/filterfavourite.dart';
import 'package:shooping_app/Providers/cart.dart';
import 'package:shooping_app/Screens/cart_screen.dart';
import 'package:shooping_app/Widgets/badge.dart';

import 'package:shooping_app/Widgets/productgrid.dart';
// import 'dart:developer' show log;

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shooping App"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (Filterfavourite value) {
              // log("$value");
              setState(() {
                if (value == Filterfavourite.favourite) {
                  _showOnlyFavourite = true;
                } else {
                  _showOnlyFavourite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: Filterfavourite.favourite,
                  // value: 0,
                  child: Text("Favourites items"),
                ),
                const PopupMenuItem(
                  value: Filterfavourite.showAll,
                  // value: 1,
                  child: Text("All items"),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Badgee(
                // value: '100'
                value: cart.productCount.toString(),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      body: ProductsGrid(
        showFavs: _showOnlyFavourite,
      ),
    );
  }
}
