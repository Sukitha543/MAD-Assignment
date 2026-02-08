import 'package:flutter/material.dart';
import 'package:mad_assignment/widgets/bottom_navigation.dart';

import 'package:mad_assignment/pages/signin_page.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/network_controller.dart';

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
    final network = Provider.of<NetworkController>(context);

    if (auth.isCheckingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget mainContent;
    if (auth.isLoggedIn) {
      mainContent = const BottomNavigation();
    } else {
      mainContent = const SigninPage();
    }

    return Scaffold(
      body: Column(
        children: [
          if (!network.isConnected)
            Container(
              color: Colors.red,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
