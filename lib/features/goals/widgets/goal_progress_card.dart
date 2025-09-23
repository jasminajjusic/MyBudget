import 'package:flutter/material.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/widgets/card_container.dart';

class GoalProgressCard extends StatelessWidget {
  final GoalModel goal;
  const GoalProgressCard({Key? key, required this.goal}) : super(key: key);

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return const Color(0xFF37C498);
      default:
        return const Color(0xFFF3F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _priorityColor(goal.priority).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  goal.priority,
                  style: TextStyle(
                    color: _priorityColor(goal.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF37C498),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$percent%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
