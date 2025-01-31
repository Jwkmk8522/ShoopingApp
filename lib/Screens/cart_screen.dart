import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';

import '../Providers/cart.dart' show Cart;
import '../Providers/orders.dart';
import '../Widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("Your Cart "),
            Text(
              " Total Items ${cart.items.length}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 1,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                    ),
                    OrderNowButton(cart: cart),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItem(
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  titlee: cart.items.values.toList()[index].title,
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cart.items.isEmpty || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clear();
              } on NoInternetExceptions catch (error) {
                showErrorDialog(context, error.message);
              } on OnUnknownExceptions catch (error) {
                showErrorDialog(context, error.message);
              } catch (error) {
                showErrorDialog(context, "something went wrong");
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              "Order Now",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
    );
  }
}
