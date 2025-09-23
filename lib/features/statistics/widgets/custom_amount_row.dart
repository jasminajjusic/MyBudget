import 'package:flutter/material.dart';

class CustomAmountRow extends StatelessWidget {
  final String currency;
  final String mainAmount;
  final String decimals;
  const CustomAmountRow({
    super.key,
    required this.currency,
    required this.mainAmount,
    required this.decimals,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: currency,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: mainAmount,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: decimals,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
