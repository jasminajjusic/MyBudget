import 'package:flutter/material.dart';

class PeriodSelectorBox extends StatelessWidget {
  final String selectedPeriod;
  final void Function(String) onPeriodChanged;

  const PeriodSelectorBox({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedPeriod,
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      items: const [
        DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
        DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
        DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
      ],
      onChanged: (value) {
        if (value != null) onPeriodChanged(value);
      },
      underline: const SizedBox(),
    );
  }
}
