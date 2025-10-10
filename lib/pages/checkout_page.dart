import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad_assignment/models/product.dart';
import 'package:mad_assignment/pages/payment_page.dart';
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
              Text(
                "Order Summary",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
              OrderNowButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => PaymentPage(totalPrice: totalPrice),
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
