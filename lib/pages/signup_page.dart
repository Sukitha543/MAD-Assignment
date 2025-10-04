import 'package:flutter/material.dart';

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
   final TextEditingController firstName= TextEditingController();
   final TextEditingController lastName = TextEditingController();
   final TextEditingController emailAddress = TextEditingController();
   final TextEditingController shippingAddress = TextEditingController();
   final TextEditingController contactNumber = TextEditingController();
   final TextEditingController username = TextEditingController();
   final TextEditingController password= TextEditingController();
   final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView( // makes it scrollable on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
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

                 CustomTextField(
                  label: "Username",
                  controller: username,
                ),
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

                // Login Button
                CustomButton(
                  text:"Sign up",
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(builder: (context) => SigninPage(),)
                      );
                  }
                  ),
                const SizedBox(height: 20),

              CustomLinkText(
                normalText:"Already Registered?",
                 linkText: "Log in", 
                 onTap: (){
                  Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(builder: (context) => SigninPage(),)
                      );
                 } )
              ],
            ),
          ),
        ),
      ),
    );
  }
}