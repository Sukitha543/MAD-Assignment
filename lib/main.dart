import 'package:flutter/material.dart';
import 'package:mad_assignment/pages/cart_page.dart';
import 'package:mad_assignment/pages/home_page.dart';
import 'package:mad_assignment/pages/product_page.dart';
import 'package:mad_assignment/pages/profile_page.dart';
import 'package:mad_assignment/pages/signin_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
int currentIndex = 0;
final List<Widget> pages = [
  HomePage(),
  ProductPage(),
  CartPage(),
  ProfilePage(),
];


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeBridge',
      home: SigninPage());}
      /*Scaffold(
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
            icon:Icon(Icons.shop),
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

      
      ),
      
    );
  }
}*/
}