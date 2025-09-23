import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/cubit/goals_cubit.dart';
import 'package:mybudget/features/goals/widgets/goal_item.dart';
import 'package:mybudget/features/goals/widgets/goal_tabs.dart';
import 'package:mybudget/features/goals/widgets/empty_goals.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class GoalsScreen extends HookWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isInProgressActive = useState(true);
    final Box<GoalModel> goalsBox = Hive.box<GoalModel>('goalsBox');

    return BlocProvider(
      create:
          (_) => GoalsCubit(
            Hive.box<GoalModel>('goalsBox'),
            Hive.box<BudgetSettingsModel>('budget_settings'),
          ),
      child: Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: Row(
                      children: [
                        const Text(
                          'My Goals',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Color(0xFFE0E0E0),
                  ),

                  GoalTabs(isInProgressActive: isInProgressActive),

                  Expanded(
                    child: BlocBuilder<GoalsCubit, List<GoalModel>>(
                      builder: (context, goals) {
                        final filteredGoals =
                            goals.where((goal) {
                              final progress =
                                  goal.currentAmount / goal.targetAmount;
                              return isInProgressActive.value
                                  ? progress < 1.0
                                  : progress >= 1.0;
                            }).toList();

                        if (filteredGoals.isEmpty) {
                          return const EmptyGoals();
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          itemCount: filteredGoals.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 24),
                          itemBuilder:
                              (context, index) =>
                                  GoalItem(goal: filteredGoals[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
