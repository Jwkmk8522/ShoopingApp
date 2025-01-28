import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shooping_app/Providers/auth.dart';
import 'package:shooping_app/Screens/auth_screen.dart';
import 'package:shooping_app/Screens/product_overview_screen.dart';

import '../firebase_options.dart';
import '../Screens/edit_products_screen.dart';
import '../Providers/cart.dart';
import '../Providers/orders.dart';
import '../Providers/products.dart';
import '../Providers/theme.dart';
import '../Screens/cart_screen.dart';
import '../Screens/order_screen.dart';
import '../Screens/product_detail_screen.dart';

import '../Screens/user_products_screen.dart';
import '../Themes/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return Themee();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themee>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return Auth();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(null, []),
            update: (context, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.item,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) {
              return Cart();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(null, []),
            update: (context, auth, previousOrders) => Orders(
                auth.token, previousOrders == null ? [] : previousOrders.items),
          ),
        ],
        child: Consumer<Auth>(builder: (context, authData, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: customLightTheme,
            darkTheme: customDarkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductsScreen.routeName: (context) =>
                  const EditProductsScreen(),
            },
          );
        }));
  }
}
