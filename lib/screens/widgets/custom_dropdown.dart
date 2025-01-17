import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<String> options;
  final String? value; // Current selected value
  final ValueChanged<String?>? onChanged; // Callback for value changes

  CustomDropdown({
    required this.labelText,
    required this.options,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      dropdownColor: Colors.black,
      value: value, // Use the current value
      onChanged: onChanged, // Call the provided onChanged function
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}