import 'package:go_router/go_router.dart';
import 'package:mybudget/features/biometrics/screens/biometrics_screen.dart';
import 'package:mybudget/features/home/widgets/main_scaffold.dart';
import '../home/screens/home_screen.dart';
import '../transactions/screens/transaction_details_screen.dart';
import '../transactions/screens/add_transaction_screen.dart';
import 'package:mybudget/features/goals/cubit/goals_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mybudget/features/routing/app_routes.dart';
import '../limits/screens/limits_screen.dart';
import 'package:mybudget/features/goals/data/models/goal_model.dart';

import 'package:mybudget/features/settings/screens/settings_screen.dart';
import 'package:mybudget/features/privacy/screens/privacy_screen.dart';
import 'package:mybudget/features/goals/screens/goals_screen.dart';
import 'package:mybudget/features/goals/screens/set_goals_screen.dart';
import 'package:mybudget/features/goals/screens/goal_details_screen.dart';
import 'package:mybudget/features/statistics/screens/statistics_screen.dart';
import 'package:mybudget/features/onboarding/screens/onboarding_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomeScreen.withProvider(),
        ),
        GoRoute(
          path: AppRoutes.statistics,
          builder: (context, state) => StatisticsScreen(),
        ),
        GoRoute(
          path: AppRoutes.goals,
          builder: (context, state) => const GoalsScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => SettingsScreen.withProvider(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.addTransaction,
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.transactionDetails}/:index',
      builder: (context, state) {
        final index = int.parse(state.pathParameters['index']!);
        return TransactionDetailsScreen(index: index);
      },
    ),

    GoRoute(
      path: AppRoutes.biometrics,
      builder: (context, state) => const BiometricScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      builder: (context, state) => PrivacyScreen(),
    ),
    GoRoute(
      path: AppRoutes.limits,
      builder: (context, state) => LimitsScreen(),
    ),
    GoRoute(
      path: AppRoutes.setGoals,
      builder: (context, state) => SetGoalsScreen(),
    ),
    GoRoute(
      path: '/goalDetails',
      builder: (context, state) {
        final goal = state.extra as GoalModel;
        return BlocProvider.value(
          value: context.read<GoalsCubit>(),
          child: GoalDetailsScreen(goal: goal),
        );
      },
    ),
  ],
);
