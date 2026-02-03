//PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//CONTROLLERS
import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
//WIDGETS
import 'package:mad_assignment/pages/signin_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
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
      title: "TimeBridge",
      debugShowCheckedModeBanner: false,
      home: SigninPage(),
    );
  }
}
