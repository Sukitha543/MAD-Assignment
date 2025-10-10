import 'package:flutter/material.dart';

class CustomLinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onTap;

  const CustomLinkText({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normalText,
          style: const TextStyle(color: Colors.black87, fontSize: 18),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
