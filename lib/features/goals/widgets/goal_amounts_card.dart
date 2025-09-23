import 'package:flutter/material.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/widgets/card_container.dart';
import 'package:mybudget/features/goals/widgets/amount_column.dart';

class GoalAmountsCard extends StatelessWidget {
  final GoalModel goal;
  const GoalAmountsCard({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AmountColumn(title: 'Saved', amount: goal.currentAmount),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          AmountColumn(title: 'Target', amount: goal.targetAmount),
        ],
      ),
    );
  }
}
