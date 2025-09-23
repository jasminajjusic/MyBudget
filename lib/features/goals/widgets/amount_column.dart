import 'package:flutter/material.dart';

class AmountColumn extends StatelessWidget {
  final String title;
  final double amount;

  const AmountColumn({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          '${amount.toStringAsFixed(2)} KM',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
