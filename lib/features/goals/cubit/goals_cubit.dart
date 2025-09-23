import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';

import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class GoalsCubit extends Cubit<List<GoalModel>> {
  final Box<GoalModel> goalsBox;
  final Box<BudgetSettingsModel> budgetBox;

  GoalsCubit(this.goalsBox, this.budgetBox) : super([]) {
    loadGoals();
  }

  void loadGoals() {
    emit(goalsBox.values.toList());
  }

  void addGoal({
    required String title,
    required String description,
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    required String priority,
    required bool isCompleted,
  }) {
    final goal = GoalModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      deadline: deadline,
      isCompleted: isCompleted,
      createdAt: DateTime.now(),
      priority: priority,
    );

    goalsBox.add(goal);
    loadGoals();
  }

  void updateGoal(GoalModel goal) {
    goal.save();
    loadGoals();
  }

  void deleteGoal(GoalModel goal) {
    goal.delete();
    loadGoals();
  }

  void topUpGoal({required GoalModel goal, required double amount}) {
    final budget = budgetBox.getAt(0);

    if (budget != null) {
      if (amount <= budget.totalBudget) {
        goal.currentAmount += amount;
        goal.save();

        budget.totalBudget -= amount;
        budget.save();

        loadGoals();
      } else {
        print('Amount exceeds total budget');
      }
    }

    loadGoals();
  }
}
