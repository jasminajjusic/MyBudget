import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDate;
  final VoidCallback onPickDate;

  const DateField({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime?>(
      valueListenable: selectedDate,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: onPickDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: "Date",
              border: OutlineInputBorder(),
            ),
            child: Text(
              value != null
                  ? "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}"
                  : "Select date",
            ),
          ),
        );
      },
    );
  }
}
