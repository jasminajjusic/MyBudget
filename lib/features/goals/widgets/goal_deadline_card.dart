import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:mybudget/features/goals/widgets/card_container.dart';

class GoalDeadlineCard extends StatelessWidget {
  final GoalModel goal;
  const GoalDeadlineCard({Key? key, required this.goal}) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/calendarr.svg', width: 24, height: 24),
          const SizedBox(width: 12),
          Text(
            'Deadline: ${_formatDate(goal.deadline)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
