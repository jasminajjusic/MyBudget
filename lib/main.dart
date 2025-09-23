import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/settings/data/models/budget_settings_model.dart';
import 'features/settings/data/models/repeating_payment.dart';
import 'features/settings/data/models/category_limit_model.dart';
import 'features/transactions/data/models/transaction_model.dart';
import 'features/goals/data/models/goal_model.dart';
import 'features/routing/app_router.dart';

import 'features/settings/cubit/repeating_payments_cubit.dart';
import 'features/settings/cubit/repeating_payment_service.dart';

late final RepeatingPaymentService repeatingService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(BudgetSettingsModelAdapter());
  Hive.registerAdapter(CategoryLimitModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(RepeatingPaymentAdapter());

  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<GoalModel>('goalsBox');
  await Hive.openBox<BudgetSettingsModel>('budget_settings');
  await Hive.openBox<CategoryLimitModel>('category_limits');
  await Hive.openBox<RepeatingPayment>('repeating_payments');

  final repeatingBox = Hive.box<RepeatingPayment>('repeating_payments');
  final repeatingCubit = RepeatingPaymentsCubit(repeatingBox);

  await repeatingCubit.processDuePayments();

  repeatingService = RepeatingPaymentService(repeatingCubit);
  repeatingService.start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyBudget',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Montserrat-Bold',
      ),
      routerConfig: router,
    );
  }
}
