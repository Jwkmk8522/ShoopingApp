import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';

import '../Providers/products.dart';
import '../Screens/edit_products_screen.dart';
import '../Utilities/show_delete_dialog.dart';

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
    final scaffoldMes = ScaffoldMessenger.of(context);
    BuildContext ctx = context;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(titlee),
        trailing: SizedBox(
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
                  try {
                    final shouldDelete = await showdeletedialog(context,
                        "Are you sure you want to Delete this Product?");
                    if (shouldDelete) {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                    }
                  } on HttpExceptions catch (error) {
                    showErrorDialog(ctx, error.message);
                  } catch (error) {
                    scaffoldMes.showSnackBar(const SnackBar(
                        content:
                            Text("Product Not Deleted something went wrong")));
                  }
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
