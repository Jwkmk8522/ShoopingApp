import 'package:flutter/material.dart';

import 'package:shooping_app/Widgets/productgrid.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shooping App"),
        centerTitle: true,
      ),
      body: const ProductsGrid(),
    );
  }
}
