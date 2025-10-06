import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
            "Contact Information")
          ),
          SizedBox(height: 25,),
          Text("Our Location"),
          Text("Colombo 3 - 41 Galle Road"),
          Text("Call Us"),
          Text("0112353787"),
          Text("Emai"),
          Text("info@TimeBridge.lk")

        ],
      ),
    );
  }
}
