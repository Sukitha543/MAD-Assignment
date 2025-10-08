import 'package:flutter/material.dart';
import 'package:mad_assignment/models/cart.dart';
import 'package:mad_assignment/pages/checkout_page.dart';
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
                   },
                  );
                },
              ),
            ),
            CheckoutSummaryCard(
              totalPrice: cart.totalPrice,
              onCheckout: (){
                  Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => CheckoutPage
                        (items:cart.items,
                        totalPrice: cart.totalPrice,),)
                      ); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
