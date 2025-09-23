import 'package:flutter/material.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/screens/goal_details_screen.dart';

class GoalItem extends StatelessWidget {
  final GoalModel goal;
  const GoalItem({required this.goal, super.key});

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();
    final isAchieved = progress >= 1.0;
    final statusText = isAchieved ? 'Achieved' : 'In progress';
    final statusColor = isAchieved ? const Color(0xFF4CAF50) : Colors.grey;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GoalDetailsScreen(goal: goal)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDFE8F6)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                const Spacer(),
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF151822),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        color: const Color(0xFF37C498),
                        backgroundColor: const Color(0xFFD6D6D6),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '$percent%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Color(0xFF37C498),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Saved',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${goal.currentAmount.toStringAsFixed(2)} KM',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Column(
                  children: [
                    const Text(
                      'Target',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${goal.targetAmount.toStringAsFixed(2)} KM',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
