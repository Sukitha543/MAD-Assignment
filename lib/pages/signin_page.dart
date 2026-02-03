//PACKAGES
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//CONTROLLERS
import 'package:mad_assignment/controllers/auth_controller.dart';
//WIDGETS
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final authController = Provider.of<AuthController>(context, listen: false);

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter both email and password",
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success = await authController.login(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => BottomNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.errorMessage ?? "Invalid email or password",
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            // makes it scrollable on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 100,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Hi, Welcome! 👋",
                  style: GoogleFonts.poppins(
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

                // Email Field
                CustomTextField(
                  label: "Email",
                  hint: "Enter Your Email",
                  controller: emailController,
                ),
                const SizedBox(height: 20),

                //Password Field
                CustomTextField(
                  label: "Password",
                  hint: "Enter Your Password",
                  obsecureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 30),

                // Login Button
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Sign in", onPressed: _handleLogin),
                const SizedBox(height: 20),
                CustomLinkText(
                  normalText: "Don't have an account?",
                  linkText: "Sign Up",
                  onTap: () {
                    Navigator.of(context).push(
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
