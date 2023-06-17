import 'package:flutter/material.dart';

class buildTextField extends StatelessWidget {
  buildTextField({
    required this.Controller,
    required this.hintText,
    required this.obscureText,
  });

  final TextEditingController Controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}