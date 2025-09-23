import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go(AppRoutes.home),
            child: const Icon(Icons.close, size: 24),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Center(
              child: Text(
                'Add transaction',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(width: 32),
        ],
      ),
    );
  }
}
