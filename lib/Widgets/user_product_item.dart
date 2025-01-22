import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/products.dart';
import 'package:shooping_app/Screens/edit_products_screen.dart';
import 'package:shooping_app/Utilities/show_delete_dialog.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String titlee;
  const UserProductItem(
      {super.key,
      required this.imageUrl,
      required this.titlee,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(titlee),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditProductsScreen.routeName,
                    arguments: id,
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  final shouldDelete = await showdeletedialog(
                      context, "Are you sure you want to Delete this Product?");
                  if (shouldDelete) {
                    Provider.of<Products>(
                      context,
                      listen: false,
                    ).deleteProduct(id);
                  }
                  return;
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
