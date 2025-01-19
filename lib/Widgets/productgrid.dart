import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';
import '../Widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({super.key, required this.showFavs});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final products = showFavs ? productData.favouriteItems : productData.item;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // create: (context) {
          //   return products[index];
          // },
          value: products[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
