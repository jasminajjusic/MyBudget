import 'package:flutter/material.dart';
import 'settings_item.dart';

class SettingsGroup extends StatelessWidget {
  final List<SettingsItem> items;

  const SettingsGroup({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          ],
        ],
      ),
    );
  }
}
