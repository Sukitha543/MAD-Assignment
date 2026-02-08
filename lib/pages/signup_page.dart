import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mad_assignment/controllers/auth_controller.dart';
import 'package:mad_assignment/pages/signin_page.dart';
import 'package:mad_assignment/widgets/custom_button.dart';
import 'package:mad_assignment/widgets/custom_link.dart';
import 'package:mad_assignment/widgets/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _handleSignup() async {
    final authController = Provider.of<AuthController>(context, listen: false);

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill in all fields",
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid email address",
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success = await authController.register(
      name: name,
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => SigninPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.errorMessage ?? "Registration failed",
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to loading state
    final isLoading = context.select<AuthController, bool>(
      (controller) => controller.isLoading,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      // backgroundColor handled by theme
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            // makes it scrollable on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  label: "Name",
                  hint: "John Doe",
                  controller: nameController,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Email Address",
                  hint: "johndoe@gmail.com",
                  controller: emailController,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Password",
                  obsecureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Confirm Password",
                  obsecureText: true,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 20),

                // Register Button
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Sign up", onPressed: _handleSignup),
                const SizedBox(height: 20),
                CustomLinkText(
                  normalText: "Already Registered?",
                  linkText: "Log in",
                  onTap: () {
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
