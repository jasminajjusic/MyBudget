import 'package:flutter/material.dart';

class IncomeSpendingsBox extends StatelessWidget {
  final String selected;
  final void Function(String) onSelectionChanged;

  const IncomeSpendingsBox({
    super.key,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged('income'),
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(right: 3, left: 4),
                decoration: BoxDecoration(
                  color:
                      selected == 'income'
                          ? const Color(0xFF151822)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 14,
                    color: selected == 'income' ? Colors.white : Colors.black,
                    fontWeight:
                        selected == 'income'
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged('expense'),
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(left: 3, right: 4),
                decoration: BoxDecoration(
                  color:
                      selected == 'expense'
                          ? const Color(0xFF151822)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Spendings",
                  style: TextStyle(
                    fontSize: 14,
                    color: selected == 'expense' ? Colors.white : Colors.black,
                    fontWeight:
                        selected == 'expense'
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
