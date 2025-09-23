import 'package:flutter/material.dart';

class CustomTextRow extends StatelessWidget {
  final String text;
  final bool isGrey;
  final double verticalPadding;
  const CustomTextRow({
    super.key,
    required this.text,
    this.isGrey = false,
    this.verticalPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: isGrey ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
