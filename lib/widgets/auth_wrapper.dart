import 'package:flutter/material.dart';
import 'package:mad_assignment/widgets/bottom_navigation.dart';

import 'package:mad_assignment/pages/signin_page.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AuthController>(
        context,
        listen: false,
      ).checkLoginStatus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    if (auth.isCheckingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isLoggedIn) {
      return const BottomNavigation();
    } else {
      return const SigninPage();
    }
  }
}
