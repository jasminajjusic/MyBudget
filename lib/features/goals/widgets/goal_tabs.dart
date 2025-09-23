import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GoalTabs extends HookWidget {
  final ValueNotifier<bool> isInProgressActive;
  const GoalTabs({required this.isInProgressActive, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => isInProgressActive.value = true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isInProgressActive.value
                          ? const Color(0xFF151822)
                          : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'In Progress',
                  style: TextStyle(
                    color:
                        isInProgressActive.value
                            ? Colors.white
                            : Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => isInProgressActive.value = false,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isInProgressActive.value
                          ? Colors.white
                          : const Color(0xFF151822),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Achieved',
                  style: TextStyle(
                    color:
                        isInProgressActive.value
                            ? Colors.black54
                            : Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    letterSpacing: -0.5,
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
