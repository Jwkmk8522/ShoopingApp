// import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Providers/products.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';
import 'package:shooping_app/Widgets/Loading/new_card_skeleton.dart';

import '../Enums/filterfavourite.dart';
import '../Providers/cart.dart';
import '../Providers/theme.dart';
import '../Screens/cart_screen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/badge.dart';
import '../Widgets/productgrid.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;

  Future<void> getProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Products>(context, listen: false).getAndSetProduct();
    } on NoProductsExceptions catch (error) {
      showErrorDialog(context, error.message);
    } on HttpExceptions catch (error) {
      showErrorDialog(context, error.message);
    } on NoInternetExceptions catch (error) {
      showErrorDialog(context, error.message);
    } on OnUnknownExceptions catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, "something went wrong");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  var _showOnlyFavourite = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themee>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shooping App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              themeProvider
                  .toggleTheme(themeProvider.themeMode == ThemeMode.dark);
            },
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
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
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 4 / 3,
              ),
              itemCount: 8,
              itemBuilder: (context, index) => const NewsCardSkelton(),
            )
          : ProductsGrid(
              showFavs: _showOnlyFavourite,
            ),
    );
  }
}
