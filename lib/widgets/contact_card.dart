import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  final String location = "41-Galle Road, Colombo 03";
  final int contact = 0112353787;
  final String email = "info@TimeBridge.lk";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(20),
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
            "Contact Information",
            style: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),)
          ),
          SizedBox(height: 25,),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey[700]),
                      ),
                  ],
                )),
            ],
          ),
          SizedBox(height: 20),
           Row(
            children: [
              Icon(
                Icons.call,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Call Us",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$contact",
                      style: TextStyle(color: Colors.grey[700]),
                      ),
                  ],
                )),
            ],
          ),
          SizedBox(height: 20),
           Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.grey[700]),
                      ),
                  ],
                )),
            ],
          ),
        ],
      ),
    );
  }
}
