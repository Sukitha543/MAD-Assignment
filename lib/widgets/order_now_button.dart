import 'package:flutter/material.dart';

class OrderNowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OrderNowButton
  ({super.key,  
  required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, 
          foregroundColor: Colors.white, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wallet, size: 22),
            SizedBox(width: 8),
            Text("ORDER NOW",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}