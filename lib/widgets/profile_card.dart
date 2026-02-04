import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.user;

    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.account_box, color: Colors.black, size: 28),
              const SizedBox(width: 10),
              Text(
                user?.name ?? "Guest User",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.black, size: 28),
              const SizedBox(width: 10),
              Text(
                user?.email ?? "No Email",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          // Placeholder for missing fields in User model
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.local_shipping, color: Colors.black, size: 28),
              const SizedBox(width: 10),
              const Text("Address not set"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.call, color: Colors.black, size: 28),
              const SizedBox(width: 10),
              const Text("No contact number"),
            ],
          ),
        ],
      ),
    );
  }
}
