import 'package:flutter/material.dart';

import 'package:mad_assignment/pages/cart_page.dart';
import 'package:mad_assignment/pages/home_page.dart';
import 'package:mad_assignment/pages/product_page.dart';
import 'package:mad_assignment/pages/profile_page.dart';
import 'package:mad_assignment/pages/signin_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  final List<Widget> pages =[
    HomePage(),
    ProductPage(),
    CartPage(),
    ProfilePage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("TimeBridge",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed:() {
               Navigator.of(context).pushReplacement(
                   MaterialPageRoute<void>(builder: (context) => SigninPage(),)
                   );
                }, 
            icon: Icon(Icons.logout),
            color: Colors.white,
            ),
        ],
      ),
      bottomNavigationBar:BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blueGrey,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          } ,
          items: [
            BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.watch),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.account_box),
            label: "Profile",
          ),
          ],
        ),
        body: pages[currentIndex],
    );
  }
}