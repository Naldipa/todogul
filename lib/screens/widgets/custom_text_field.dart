import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final int maxLines;
  final TextEditingController? controller;

  CustomTextField({
    required this.hintText,
    required this.labelText,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style:
          TextStyle(color: Colors.white), // Menambahkan style untuk teks input
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}