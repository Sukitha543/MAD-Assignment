import 'package:flutter/material.dart';

import 'package:mad_assignment/pages/cart_page.dart';
import 'package:mad_assignment/pages/favorites_page.dart';
import 'package:mad_assignment/pages/home_page.dart';
import 'package:mad_assignment/pages/product_page.dart';
import 'package:mad_assignment/pages/profile_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    ProductPage(),
    CartPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "TIMEBRIDGE",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.6),
        backgroundColor: Theme.of(
          context,
        ).bottomAppBarTheme.color, // Optional: ensure bg is correct
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.watch), label: "Products"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "favorites",
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
