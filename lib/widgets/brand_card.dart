import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final String imageUrl;

  const BrandCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {  
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        imageUrl,
        width: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}
