import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mybudget/features/home/widgets/action_icons_box.dart';
import 'package:mybudget/features/home/widgets/header_widget.dart';
import 'package:mybudget/features/home/widgets/balance_widget.dart';
import 'package:mybudget/features/home/widgets/filter_selector.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  static Widget withProvider() {
    return BlocProvider(
      create: (_) => BudgetSettingsCubit(),
      child: const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilterIndex = useState(0);
    final filters = ['1 Day', '1 Week', '1 Month', '1 Year', 'All'];

    final openBoxFuture = useMemoized(
      () => Hive.openBox<TransactionModel>('transactions'),
    );
    final boxSnapshot = useFuture(openBoxFuture);

    void onFilterTapped(int index) {
      selectedFilterIndex.value = index;
    }

    if (boxSnapshot.connectionState != ConnectionState.done) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final box = Hive.box<TransactionModel>('transactions');

    List<TransactionModel> filteredTransactions(
      List<TransactionModel> allTransactions,
      int filterIndex,
    ) {
      final now = DateTime.now();
      switch (filterIndex) {
        case 0:
          final oneDayAgo = now.subtract(const Duration(days: 1));
          return allTransactions
              .where((tx) => tx.date.isAfter(oneDayAgo))
              .toList();
        case 1:
          final oneWeekAgo = now.subtract(const Duration(days: 7));
          return allTransactions
              .where((tx) => tx.date.isAfter(oneWeekAgo))
              .toList();
        case 2:
          final oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
          return allTransactions
              .where((tx) => tx.date.isAfter(oneMonthAgo))
              .toList();
        case 3:
          final oneYearAgo = DateTime(now.year - 1, now.month, now.day);
          return allTransactions
              .where((tx) => tx.date.isAfter(oneYearAgo))
              .toList();
        case 4:
        default:
          return allTransactions;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF3F5F9)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\ KM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FilterSelector(
                  filters: filters,
                  selectedIndex: selectedFilterIndex.value,
                  onFilterSelected: onFilterTapped,
                ),
              ),
              const SizedBox(height: 24),

              ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<TransactionModel> box, _) {
                  if (box.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No transactions yet.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }

                  final allTransactions =
                      box.values.toList().cast<TransactionModel>();

                  final transactions = filteredTransactions(
                    allTransactions,
                    selectedFilterIndex.value,
                  );

                  if (transactions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No transactions for this filter.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < transactions.length; i++) ...[
                            GestureDetector(
                              onTap:
                                  () => context.go(
                                    '${AppRoutes.transactionDetails}/$i',
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                child: _buildTransaction(
                                  title: transactions[i].category,
                                  amount: transactions[i].amount
                                      .toStringAsFixed(2),
                                  icon:
                                      transactions[i].transactionType ==
                                              'Income'
                                          ? 'income.svg'
                                          : 'payy.svg',
                                  isIncome:
                                      transactions[i].transactionType ==
                                      'Income',
                                ),
                              ),
                            ),
                            if (i < transactions.length - 1) _divider(),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(color: Color(0xFF151822)),
        ),
        Column(
          children: const [HeaderWidget(), BalanceWidget(), ActionIconsBox()],
        ),
      ],
    );
  }

  Widget _buildTransaction({
    required String title,
    required String amount,
    required String icon,
    required bool isIncome,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF151822),
              borderRadius: BorderRadius.circular(6),
            ),
            child: SvgPicture.asset(
              'assets/icons/$icon',
              height: 16,
              width: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Text(
            '${isIncome ? '+ ' : '- '}$amount',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: const Color.fromARGB(255, 252, 248, 248),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
