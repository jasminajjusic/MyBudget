import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/goals/widgets/goal_form.dart';
import 'package:mybudget/features/routing/app_routes.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';
import 'package:hive/hive.dart';

class SetGoalsScreen extends HookWidget {
  const SetGoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Set Goals',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFE1E1E1)),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: GoalForm(goalsBox: Hive.box<GoalModel>('goalsBox')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
