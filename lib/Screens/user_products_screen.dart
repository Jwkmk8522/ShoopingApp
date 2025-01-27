import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';

import '../Screens/edit_products_screen.dart';
import '../Providers/products.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductsScreen';
  const UserProductsScreen({super.key});

  Future<void> onRefreshh(BuildContext context) async {
    try {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // In this we dont write listen false because when we delete Product
    // we again listen or rebuild the widget
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => onRefreshh(context),
        child: ListView.builder(
          itemCount: productData.item.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                UserProductItem(
                  id: productData.item[index].id,
                  imageUrl: productData.item[index].imageUrl,
                  titlee: productData.item[index].title,
                ),
                const Divider()
              ],
            );
          },
        ),
      ),
    );
  }
}
