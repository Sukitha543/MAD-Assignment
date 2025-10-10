import 'package:flutter/material.dart';
import 'package:mad_assignment/pages/signin_page.dart';

void main() {
  runApp(const MyApp());
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
