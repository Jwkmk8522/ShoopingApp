import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Providers/cart.dart';
import 'package:shooping_app/Providers/orders.dart';
import 'package:shooping_app/Providers/products.dart';
import 'package:shooping_app/Providers/theme.dart';
import 'package:shooping_app/Screens/cart_screen.dart';
import 'package:shooping_app/Screens/order_screen.dart';
//...
import 'package:shooping_app/Screens/product_detail_screen.dart';
import 'package:shooping_app/Screens/product_overview_screen.dart';
import 'package:shooping_app/Themes/dark_theme.dart';

void main() {
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
        debugShowCheckedModeBanner: false,
        theme: customLightTheme,
        darkTheme: customDarkTheme,
        themeMode: themeProvider.themeMode,
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
        },
      ),
    );
  }
}
