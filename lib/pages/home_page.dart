import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: Text("HomePage"),
          )
        ),
      ),
    );
  }
}