import 'package:flutter/material.dart';

class EditUserTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;

  const EditUserTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Color(0xFFFAF9F6), // Text color inside TextField
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFFFAF9F6),
        ),
        focusColor: Color(0xFFFAF9F6),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFAF9F6),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFAF9F6),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFAF9F6),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: enabled ? Colors.transparent : Colors.grey.shade500, // Light grey when disabled
      ),
      enabled: enabled,
    );
  }
}