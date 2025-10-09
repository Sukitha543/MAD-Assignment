import 'package:flutter/material.dart';

import 'package:mad_assignment/models/cart.dart';
import 'package:mad_assignment/pages/checkout_page.dart';
import 'package:mad_assignment/widgets/bottom_navigation.dart';
import 'package:mad_assignment/widgets/cart_item_card.dart';
import 'package:mad_assignment/widgets/checkout_summary_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = Cart.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return CartItemCard(
                    product: product,
                    onDelete: () {
                      setState(() {
                        cart.removeItem(product);
                      });
                      // Check if cart becomes empty after removing an item
                      if (cart.items.isEmpty) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (context) => BottomNavigation(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Your cart is now empty! Returned to Home Page.",
                              style: TextStyle(fontSize: 18),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            CheckoutSummaryCard(
              totalPrice: cart.totalPrice,
              onCheckout: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => CheckoutPage(
                      items: cart.items,
                      totalPrice: cart.totalPrice,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
