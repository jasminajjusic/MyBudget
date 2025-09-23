import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/income_spendings_box.dart';
import '../widgets/statistics_chart.dart';
import '../widgets/category_card.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:mybudget/features/transactions/cubit/add_transaction_cubit.dart';
import 'package:mybudget/features/transactions/state/add_transaction_state.dart';
import 'package:mybudget/features/statistics/widgets/repeating_payments_box.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_routes.dart';

class StatisticsScreen extends HookWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedType = useState('income');
    final selectedPeriod = useState('weekly');

    return BlocProvider<AddTransactionCubit>(
      create: (context) => AddTransactionCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => context.go(AppRoutes.home),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Statistics",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 0.7,
                  height: 0,
                  color: Color(0xFFE0E0E0),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IncomeSpendingsBox(
                    selected: selectedType.value,
                    onSelectionChanged: (value) {
                      selectedType.value = value;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StatisticsChart(
                    selectedType: selectedType.value,
                    selectedPeriod: selectedPeriod.value,
                    onPeriodChanged: (period) {
                      selectedPeriod.value = period;
                    },
                  ),
                ),

                const SizedBox(height: 8),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Repeating Payments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RepeatingPaymentsBoxWrapper(),
                ),

                if (selectedType.value == 'expense') ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Spending categories',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<
                      AddTransactionCubit,
                      AddTransactionState
                    >(
                      builder: (context, state) {
                        final List<TransactionModel> transactions =
                            state.transactions
                                .where(
                                  (tx) =>
                                      tx.transactionType.toLowerCase() ==
                                      selectedType.value,
                                )
                                .toList();

                        final Map<String, double> categoryTotals = {};
                        double totalAmount = 0;

                        for (var tx in transactions) {
                          categoryTotals[tx.category] =
                              (categoryTotals[tx.category] ?? 0) + tx.amount;
                          totalAmount += tx.amount;
                        }

                        final categoryCards =
                            categoryTotals.entries.map((entry) {
                              final name = entry.key;
                              final spent = entry.value;
                              final percent =
                                  totalAmount == 0 ? 0 : spent / totalAmount;
                              final color =
                                  Colors.primaries[name.hashCode %
                                      Colors.primaries.length];

                              return CategoryCard(
                                category: {
                                  'name': name,
                                  'spent': spent,
                                  'percent': percent,
                                  'color': color,
                                  'icon':
                                      'assets/icons/${name.toLowerCase()}.svg',
                                },
                              );
                            }).toList();

                        return Column(children: categoryCards);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
