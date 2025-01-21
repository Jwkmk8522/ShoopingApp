import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../Screens/edit_products_screen.dart';
import '../Providers/cart.dart';
import '../Providers/orders.dart';
import '../Providers/products.dart';
import '../Providers/theme.dart';
import '../Screens/cart_screen.dart';
import '../Screens/order_screen.dart';
import '../Screens/product_detail_screen.dart';
import '../Screens/product_overview_screen.dart';
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
            return Products();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return Cart();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return Orders();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: customLightTheme,
        darkTheme: customDarkTheme,
        themeMode: themeProvider.themeMode,
        debugShowCheckedModeBanner: false,
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          EditProductsScreen.routeName: (context) => const EditProductsScreen(),
        },
      ),
    );
  }
}
