import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/cart.dart';
import 'package:shooping_app/Providers/product.dart';
import 'package:shooping_app/Screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Product without listening to it (no rebuild)
    final product = Provider.of<Product>(
      context,
    );
    // Access Cart without listening to it (no rebuild)
    final cart = Provider.of<Cart>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,

          // Consumer is used only for the part that needs to rebuild
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                product.toogleFavouriteStatus();
              },
            ),
          ),
          title: Text(
            product.title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.additems(
                product.id,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Item added to the cart succesfuly ..."),
                  duration: const Duration(seconds: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.black,
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
