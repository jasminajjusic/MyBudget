import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:mybudget/features/goals/widgets/action_button.dart';
import 'package:mybudget/features/goals/widgets/goal_progress_card.dart';
import 'package:mybudget/features/goals/widgets/goal_deadline_card.dart';
import 'package:mybudget/features/goals/widgets/goal_amounts_card.dart';
import 'package:mybudget/features/goals/widgets/goal_description_card.dart';
import 'package:mybudget/features/goals/widgets/top_up_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import 'package:mybudget/features/goals/cubit/goals_cubit.dart';

class GoalDetailsView extends StatelessWidget {
  final GoalModel goal;

  const GoalDetailsView({Key? key, required this.goal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: const Color(0xFFF3F5F9),
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/left_arrow.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () => context.go(AppRoutes.goals),
          ),
          title: const Text(
            'Goal Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: Color(0xFFE0E0E0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            GoalProgressCard(goal: goal),
            const SizedBox(height: 16),
            GoalDeadlineCard(goal: goal),
            const SizedBox(height: 16),
            GoalAmountsCard(goal: goal),
            const SizedBox(height: 16),
            GoalDescriptionCard(goal: goal),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Top Up',
                    icon: Icons.add_circle_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF37C498), Color(0xFF2E9F82)],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (ctx) => BlocProvider.value(
                              value: context.read<GoalsCubit>(),
                              child: TopUpBottomSheet(goal: goal),
                            ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline,
                    color: Colors.redAccent,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                'Do you really want to delete this goal?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<GoalsCubit>().deleteGoal(goal);
                                    Navigator.of(ctx).pop();
                                    context.go(AppRoutes.goals);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
