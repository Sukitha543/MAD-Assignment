import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad_assignment/controllers/cart_controller.dart';
import 'package:mad_assignment/controllers/favorite_controller.dart';
import 'package:mad_assignment/models/product.dart';
import 'package:mad_assignment/widgets/add_to_cart_button.dart';
import 'package:mad_assignment/widgets/favorite_button.dart';
import 'package:mad_assignment/widgets/spec_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isAddingToCart = false;
  bool _isAddingToFavorites = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product details"),
          centerTitle: true,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Colors.white,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                SizedBox(height: 10),
                ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "${widget.product.brand} - ${widget.product.model}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "\$${widget.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpecCard(product: widget.product),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AddToCartButton(
                            isLoading: _isAddingToCart,
                            onPressed: () async {
                              setState(() {
                                _isAddingToCart = true;
                              });

                              final controller = Provider.of<CartController>(
                                context,
                                listen: false,
                              );

                              // Show loading or just fire and forget but showing feedback is better
                              final result = await controller.addToCart(
                                widget.product.id,
                              );

                              if (!mounted) return;

                              setState(() {
                                _isAddingToCart = false;
                              });

                              if (result == 'added') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${widget.product.model} added to cart",
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
                        ),
                        SizedBox(width: 16),
                        FavoriteButton(
                          isLoading: _isAddingToFavorites,
                          onPressed: () async {
                            setState(() {
                              _isAddingToFavorites = true;
                            });

                            final favController =
                                Provider.of<FavoriteController>(
                                  context,
                                  listen: false,
                                );
                            final result = await favController.addFavorite(
                              widget.product.id,
                            );

                            if (!mounted) return;

                            setState(() {
                              _isAddingToFavorites = false;
                            });

                            if (result == 'added') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${widget.product.model} added to favorites",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (result == 'exists') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Already in favorites",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            } else if (result == 'unauthenticated') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please sign in to add favorites",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Failed to add to favorites",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
