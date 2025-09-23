import 'package:flutter/material.dart';

class DeadlineInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String timeText;

  const DeadlineInput({
    Key? key,
    required this.controller,
    required this.onTap,
    required this.timeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deadline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: true,
                    onTap: onTap,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: 'Enter deadline',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Text(
                  timeText,
                  style: const TextStyle(
                    color: Color(0xFF24784C),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
