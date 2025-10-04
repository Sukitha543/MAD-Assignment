import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final dynamic hint;
  final TextEditingController controller;
  final bool obsecureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.obsecureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obsecureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black45),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
