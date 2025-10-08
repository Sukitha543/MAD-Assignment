import 'package:flutter/material.dart';
import 'package:mad_assignment/models/product.dart';
import 'package:mad_assignment/widgets/checkout_total.dart';
import 'package:mad_assignment/widgets/order_card.dart';
import 'package:mad_assignment/widgets/order_now_button.dart';

class CheckoutPage extends StatelessWidget {
  final List<Product> items;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.items,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Checkout"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Order Summary"),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return OrderCard(items: product);
                    },
                  ),
                ),
              CheckoutTotal(totalPrice: totalPrice),
              const SizedBox(height: 10),
              OrderNowButton(onPressed:() {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order Confirmed!"),
                      backgroundColor: Colors.green,
                    ),
                 );
              }, 
            ),
            const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}