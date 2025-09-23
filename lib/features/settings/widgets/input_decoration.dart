import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  required String label,
  required String hint,
  IconData? icon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(fontSize: 13),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    suffixIcon: icon != null ? Icon(icon, size: 18) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF37C498), width: 1.5),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}
