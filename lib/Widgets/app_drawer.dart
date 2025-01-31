import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth.dart';
import '../Utilities/logout_dialog.dart';
import '../Screens/order_screen.dart';
import '../Screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              width: MediaQuery.of(context).size.height * 0.2,
              alignment: Alignment.center,
              child: Text(
                "Hellow Users",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            trailing:
                Text('Shop', style: Theme.of(context).textTheme.titleMedium),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.payments,
            ),
            trailing: Text(
              'Orders',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            trailing: Text(
              'Manage Products',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            trailing: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () async {
              final shouldLogOut = await showLogOutDialog(
                  context, "Are you sure you want to logout ?", "Logout");
              if (shouldLogOut) {
                Provider.of<Auth>(context, listen: false).logOutUser();
              }
            },
          ),
        ],
      ),
    );
  }
}
