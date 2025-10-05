import 'package:flutter/material.dart';
import 'package:mad_assignment/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard(
    {super.key,
     required this.product,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
          child: Card(
             margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(product.model,
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text("\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
    ),
    ),
    );
  }
}