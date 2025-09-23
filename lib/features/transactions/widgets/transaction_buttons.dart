import 'package:flutter/material.dart';

class TransactionButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const TransactionButtons({
    super.key,
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF151822)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF151822), fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF151822),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child:
                isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      'Add Transaction',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
          ),
        ),
      ],
    );
  }
}
