import 'package:flutter/material.dart';

import 'package:mad_assignment/data/user_data.dart';
import 'package:mad_assignment/pages/signup_page.dart';
import 'package:mad_assignment/widgets/bottom_navigation.dart';
import 'package:mad_assignment/widgets/custom_button.dart';
import 'package:mad_assignment/widgets/custom_link.dart';
import 'package:mad_assignment/widgets/custom_text_field.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            // makes it scrollable on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Text
                const Text(
                  "Hi, Welcome! 👋",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Login",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                const SizedBox(height: 40),

                // Username Field
                CustomTextField(
                  label: "Username",
                  hint: "Enter Your Username",
                  controller: username,
                ),
                const SizedBox(height: 20),

                //Password Field
                CustomTextField(
                  label: "Password",
                  hint: "Enter Your Password",
                  obsecureText: true,
                  controller: password,
                ),
                const SizedBox(height: 30),

                // Login Button
                CustomButton(
                  text: "Sign in",
                  onPressed: () {
                    String enteredUsername = username.text.trim();
                    String enteredPassword = password.text.trim();

                    if (enteredUsername.isEmpty || enteredPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter both username and password",style: TextStyle(fontSize: 18),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (enteredUsername == user.username &&
                        enteredPassword == user.password) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => BottomNavigation(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid username or password", style: TextStyle(fontSize: 18),),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomLinkText(
                  normalText: "Don't have an account?",
                  linkText: "Sign Up",
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (context) => SignupPage(),
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
