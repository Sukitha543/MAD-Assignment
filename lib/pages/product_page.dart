import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("TimeBridge", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed:() {
             // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logout Pressed")));
            }, 
            icon: Icon(Icons.logout),
            color: Colors.white,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Text("PRODUCTS"),
          )
        ),
      ),
    );
  }
}