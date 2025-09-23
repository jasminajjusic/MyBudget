import 'package:flutter/material.dart';

class FilterSelector extends StatelessWidget {
  final List<String> filters;
  final Function(int) onFilterSelected;
  final int selectedIndex;

  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(filters.length, (index) {
        final bool isActive = index == selectedIndex;
        return GestureDetector(
          onTap: () => onFilterSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF151822) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
