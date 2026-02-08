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
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.87),
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
