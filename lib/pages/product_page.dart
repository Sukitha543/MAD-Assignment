import 'package:flutter/material.dart';
import 'package:mad_assignment/data/product_data.dart';
import 'package:mad_assignment/pages/product_details_page.dart';
import 'package:mad_assignment/widgets/product_card.dart'; 

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductData().productList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Watches"),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
                Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => ProductDetailsPage(product: product,),)
                      ); 
              },
          );
        },
      ),
    );
  }
}
