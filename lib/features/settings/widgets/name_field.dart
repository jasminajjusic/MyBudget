import 'package:flutter/material.dart';
import 'input_decoration.dart';

class NameField extends StatelessWidget {
  final TextEditingController controller;
  const NameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: buildInputDecoration(label: "Name", hint: "Enter name"),
    );
  }
}
