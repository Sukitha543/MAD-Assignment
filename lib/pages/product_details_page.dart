import 'package:flutter/material.dart';
import 'package:mad_assignment/models/cart.dart';
import 'package:mad_assignment/models/product.dart';
import 'package:mad_assignment/widgets/add_to_cart_button.dart';
import 'package:mad_assignment/widgets/spec_card.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Product details"),
        centerTitle: true,
        backgroundColor: Colors.black, 
        foregroundColor: Colors.white,
        elevation: 2,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                SizedBox(height: 10,),
                ClipRRect(
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "${product.brand} - ${product.model}",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpecCard(product: product,),
                    SizedBox(height: 10,),
                    AddToCartButton(onPressed: () {
                       Cart.instance.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${product.model} added to cart")),
                        );
                    },)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
