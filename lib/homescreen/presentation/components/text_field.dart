import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters; // Added inputFormatters parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.keyboardType,
    this.validator,
    this.inputFormatters, // Allow passing input formatters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // Apply input formatters
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
