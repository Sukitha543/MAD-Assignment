import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad_assignment/data/user_data.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

 
  @override
  Widget build(BuildContext context) {
    
   final userData = user;

    return Container(
      width: 320,
      margin:EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Text(
              "Account Details",
              style: GoogleFonts.poppins(
              fontSize:20,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[800],
              )
              ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                Icons.account_box,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 10,),
              Text("${userData.firstName} ${userData.lastName}"),
              ],
            ),
             SizedBox(height: 20),
             Row(
              children: [
                Icon(
                Icons.local_shipping,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 10,),
              Text(userData.shippingAddress),
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
              SizedBox(width: 10,),
              Text(userData.emailAddress),
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
              SizedBox(width: 10,),
              Text("${userData.contactNumber}"),
              ],
            ),
            
        ],
      
      ),
    );
  }
}