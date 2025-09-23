import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final ValueNotifier<TimeOfDay?> selectedTime;
  final VoidCallback onPickTime;

  const TimeField({
    super.key,
    required this.selectedTime,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TimeOfDay?>(
      valueListenable: selectedTime,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: onPickTime,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: "Time",
              border: OutlineInputBorder(),
            ),
            child: Text(value != null ? value.format(context) : "Select time"),
          ),
        );
      },
    );
  }
}
