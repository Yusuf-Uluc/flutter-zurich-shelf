import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isPassword,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        labelText: labelText,
      ),
    );
  }
}
