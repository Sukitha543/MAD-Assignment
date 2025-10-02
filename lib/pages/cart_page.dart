import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
            child: Text("CART"),
          )
        ),
      ),
    );
  }
}