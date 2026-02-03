import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:mad_assignment/controllers/auth_controller.dart';
import 'package:mad_assignment/models/cart.dart';
import 'package:mad_assignment/pages/signin_page.dart';
import 'package:mad_assignment/widgets/logout_button.dart';
import 'package:mad_assignment/widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                ProfileCard(),
                SizedBox(height: 20),
                LogoutButton(
                  onPressed: () {
                    // Properly log out via controller to clear token
                    Provider.of<AuthController>(
                      context,
                      listen: false,
                    ).logout();
                    Cart.instance.clearCart();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (context) => SigninPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
