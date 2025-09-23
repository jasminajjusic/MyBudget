import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/widgets/goal_details_view.dart';
import 'package:mybudget/features/goals/cubit/goals_cubit.dart';

import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class GoalDetailsScreen extends StatelessWidget {
  final GoalModel goal;

  const GoalDetailsScreen({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => GoalsCubit(
            Hive.box<GoalModel>('goalsBox'),
            Hive.box<BudgetSettingsModel>('budget_settings'),
          ),
      child: GoalDetailsView(goal: goal),
    );
  }
}
