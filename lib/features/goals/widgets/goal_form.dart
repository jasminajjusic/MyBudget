import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/goals/cubit/goals_cubit.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import 'title_input.dart';
import 'deadline_input.dart';
import 'amount_input.dart';
import 'description_input.dart';
import 'priority_dropdown.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class GoalForm extends HookWidget {
  final Box<GoalModel> goalsBox;

  const GoalForm({Key? key, required this.goalsBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => GoalsCubit(
            Hive.box<GoalModel>('goalsBox'),
            Hive.box<BudgetSettingsModel>('budget_settings'),
          ),
      child: const _GoalFormContent(),
    );
  }
}

class _GoalFormContent extends HookWidget {
  const _GoalFormContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final deadlineController = useTextEditingController();
    final targetAmountController = useTextEditingController();
    final currentAmountController = useTextEditingController();
    final descriptionController = useTextEditingController();

    final selectedDate = useState<DateTime?>(null);
    final selectedPriority = useState<String>('Low');

    return BlocConsumer<GoalsCubit, List<GoalModel>>(
      listener: (context, goalsList) {},
      builder: (context, goalsList) {
        final goalsCubit = context.read<GoalsCubit>();

        void onSave() {
          final title = titleController.text.trim();
          final description = descriptionController.text.trim();
          final targetAmountText = targetAmountController.text.trim();
          final currentAmountText = currentAmountController.text.trim();
          final deadlineText = deadlineController.text.trim();

          if (title.isEmpty ||
              description.isEmpty ||
              targetAmountText.isEmpty ||
              currentAmountText.isEmpty ||
              deadlineText.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in all required fields'),
              ),
            );
            return;
          }

          final targetAmount = double.tryParse(targetAmountText);
          final currentAmount = double.tryParse(currentAmountText);

          if (targetAmount == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid target amount')),
            );
            return;
          }

          if (currentAmount == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid current amount')),
            );
            return;
          }

          final deadline = selectedDate.value;
          if (deadline == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a deadline')),
            );
            return;
          }

          goalsCubit.addGoal(
            title: title,
            description: description,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            isCompleted: false,
            priority: selectedPriority.value,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Goal added successfully')),
          );

          context.go(AppRoutes.home);
        }

        Future<void> selectDate() async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate.value ?? now,
            firstDate: now,
            lastDate: DateTime(now.year + 10),
          );
          if (picked != null && picked != selectedDate.value) {
            selectedDate.value = picked;
            deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
          }
        }

        String timeToReachGoal() {
          if (selectedDate.value == null) return '';
          final now = DateTime.now();
          Duration diff = selectedDate.value!.difference(now);

          if (diff.isNegative) return 'Deadline passed';

          int years = diff.inDays ~/ 365;
          int months = (diff.inDays % 365) ~/ 30;
          int days = (diff.inDays % 365) % 30;

          if (years > 0) return years == 1 ? '1 year' : '$years years';
          if (months > 0) return months == 1 ? '1 month' : '$months months';
          if (days > 0) return days == 1 ? '1 day' : '$days days';
          return 'Today';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TitleInput(controller: titleController),
            const SizedBox(height: 20),
            DeadlineInput(
              controller: deadlineController,
              onTap: selectDate,
              timeText: timeToReachGoal(),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Target Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            AmountInput(controller: targetAmountController),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Current Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            AmountInput(controller: currentAmountController),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            DescriptionInput(controller: descriptionController),
            const SizedBox(height: 20),
            PriorityDropdown(
              selectedPriority: selectedPriority.value,
              onChanged: (val) {
                if (val != null) selectedPriority.value = val;
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF151822),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}
