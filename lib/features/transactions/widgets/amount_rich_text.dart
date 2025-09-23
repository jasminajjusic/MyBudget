import 'package:flutter/material.dart';

class AmountRichText extends StatelessWidget {
  final double amount;

  const AmountRichText({Key? key, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = amount.toStringAsFixed(2).split('.');
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          children: [
            TextSpan(
              text: parts[0],
              style: const TextStyle(fontSize: 37, fontWeight: FontWeight.w300),
            ),
            TextSpan(
              text: '.${parts[1]}',
              style: const TextStyle(fontSize: 27),
            ),
          ],
        ),
      ),
    );
  }
}
