import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            child: Text("PROFILE"),
          )
        ),
      ),
    );
  }
}