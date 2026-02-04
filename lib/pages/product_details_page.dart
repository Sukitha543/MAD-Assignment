import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_assignment/controllers/cart_controller.dart';
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
        appBar: AppBar(
          title: Text("Product details"),
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
                SizedBox(height: 10),
                ClipRRect(
                  child: product.image.startsWith('http')
                      ? Image.network(
                          product.image,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),
                        )
                      : Image.asset(
                          product.image,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.watch, size: 100),
                        ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "${product.brand} - ${product.model}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpecCard(product: product),
                    SizedBox(height: 10),
                    AddToCartButton(
                      onPressed: () async {
                        final controller = Provider.of<CartController>(
                          context,
                          listen: false,
                        );

                        // Show loading or just fire and forget but showing feedback is better
                        final result = await controller.addToCart(product.id);

                        if (!context.mounted) return;

                        if (result == 'added') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${product.model} added to cart",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (result == 'exists') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Item already in cart",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        } else if (result == 'unauthenticated') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please sign in to add items",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Failed to add to cart",
                                style: TextStyle(fontSize: 18),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
