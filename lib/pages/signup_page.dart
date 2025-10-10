import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController shippingAddress = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  label: "First Name",
                  hint: "Jhon",
                  controller: firstName,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Last Name",
                  hint: "Doe",
                  controller: lastName,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Email Address",
                  hint: "jhondoe@gmail.com",
                  controller: emailAddress,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Shipping Address",
                  hint: "Colombo,Sri Lanka",
                  controller: shippingAddress,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Comtact Number",
                  controller: contactNumber,
                ),
                const SizedBox(height: 20),

                CustomTextField(label: "Username", controller: username),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Password",
                  obsecureText: true,
                  controller: password,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Confirm Password",
                  obsecureText: true,
                  controller: confirmPassword,
                ),
                const SizedBox(height: 20),

                // Register Button
                CustomButton(
                  text: "Sign up",
                  onPressed: () {
                    String fName = firstName.text.trim();
                    String lName = lastName.text.trim();
                    String email = emailAddress.text.trim();
                    String address = shippingAddress.text.trim();
                    String contact = contactNumber.text.trim();
                    String user = username.text.trim();
                    String pass = password.text.trim();
                    String confirmPass = confirmPassword.text.trim();

                    if (fName.isEmpty ||
                        lName.isEmpty ||
                        email.isEmpty ||
                        address.isEmpty ||
                        contact.isEmpty ||
                        user.isEmpty ||
                        pass.isEmpty ||
                        confirmPass.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill in all fields", style: TextStyle(fontSize: 18)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid email address",style: TextStyle(fontSize: 18)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (pass != confirmPass) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Passwords do not match",style: TextStyle(fontSize: 18)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (contact.length < 9) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid contact number",style: TextStyle(fontSize: 18)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registered Sucessfully",style: TextStyle(fontSize: 18)),
                          backgroundColor: Colors.green,
                        ),
                      );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (context) => SigninPage(),
                      ),
                    );
                    }
                  },
                ),
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
