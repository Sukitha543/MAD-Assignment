//PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//CONTROLLERS
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/product_controller.dart';
//WIDGETS
import 'package:mad_assignment/widgets/auth_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => FavoriteController()),
      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TIMEBRIDGE",
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
