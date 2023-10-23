import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.grey[50],
          filled: true),
    );
  }
}
