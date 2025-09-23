import 'package:flutter/material.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/widgets/card_container.dart';

class GoalDescriptionCard extends StatelessWidget {
  final GoalModel goal;
  const GoalDescriptionCard({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(goal.description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
