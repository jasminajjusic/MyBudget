import 'package:flutter/material.dart';

class PriorityDropdown extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String?> onChanged;

  const PriorityDropdown({
    Key? key,
    required this.selectedPriority,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Priority',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 5),

        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
            dropdownColor: Colors.white,
            value: selectedPriority,
            items: [
              DropdownMenuItem(
                value: 'Low',
                child: Text(
                  'Low',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'Medium',
                child: Text(
                  'Medium',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'High',
                child: Text(
                  'High',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
