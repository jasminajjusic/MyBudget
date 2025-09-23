import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import '../../routing/app_routes.dart';
import 'package:mybudget/features/transactions/widgets/transaction_input_fields.dart';
import 'package:mybudget/features/transactions/widgets/transaction_header.dart';
import 'package:mybudget/features/transactions/widgets/transaction_buttons.dart';
import 'package:mybudget/features/transactions/state/add_transaction_state.dart';
import 'package:mybudget/features/transactions/cubit/add_transaction_cubit.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTransactionScreen extends HookWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = useTextEditingController();
    final categoryController = useTextEditingController();
    final noteController = useTextEditingController();

    final transactionType = useState('Expense');
    final selectedDate = useState(DateTime.now());

    return BlocProvider(
      create: (_) => AddTransactionCubit(),
      child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
        listener: (context, state) {
          if (state.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!context.mounted) return;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 40,
                          bottom: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                'assets/icons/success.svg',
                                width: 48,
                                height: 48,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Transaction saved successfully',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF151822),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (context.mounted) {
                                      context.go(AppRoutes.home);
                                    }
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            });
          } else if (state.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            });
          }
        },
        builder: (context, state) {
          final addTransactionCubit = context.read<AddTransactionCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  const TransactionHeader(),
                  const Divider(height: 1, thickness: 0.5, color: Colors.grey),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: TransactionInputFields(
                        amountController: amountController,
                        categoryController: categoryController,
                        noteController: noteController,
                        selectedDate: selectedDate,
                        transactionType: transactionType,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TransactionButtons(
                      isSaving: state.isSaving,
                      onCancel: () => context.go(AppRoutes.home),
                      onSave: () async {
                        final amountText = amountController.text.trim();
                        final amount = double.tryParse(amountText);

                        if (amount == null || amount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid amount'),
                            ),
                          );
                          return;
                        }

                        if (transactionType.value == 'Expense') {
                          final category = categoryController.text.trim();

                          final settingsBox =
                              await Hive.openBox<BudgetSettingsModel>(
                                'budget_settings',
                              );
                          final settings = settingsBox.get('settings');

                          if (settings != null) {
                            final limitModel = settings.limits.firstWhereOrNull(
                              (l) => l.category == category,
                            );

                            if (limitModel != null) {
                              final transactionsBox =
                                  await Hive.openBox<TransactionModel>(
                                    'transactions',
                                  );

                              final now = DateTime.now();
                              final currentSum = transactionsBox.values
                                  .where(
                                    (t) =>
                                        t.category == category &&
                                        t.transactionType == 'Expense' &&
                                        t.date.month == now.month &&
                                        t.date.year == now.year,
                                  )
                                  .fold(0.0, (prev, t) => prev + t.amount);

                              if (currentSum + amount > limitModel.limit) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24.0,
                                            vertical: 20.0,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: const BoxDecoration(
                                                  color: const Color(
                                                    0xFF151822,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    'assets/icons/warning.svg',
                                                    width: 28,
                                                    height: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Limit Exceeded',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFF151822,
                                                  ),
                                                  letterSpacing: 0.5,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                    height: 1.5,
                                                  ),
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Limit: ',
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${limitModel.limit.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.redAccent,
                                                        fontSize: 16,
                                                      ),
                                                    ),

                                                    const TextSpan(
                                                      text:
                                                          '\nCurrent month total: ',
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${currentSum.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blueGrey,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF151822),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                    elevation: 2,
                                                  ),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );

                                return;
                              }
                            }
                          }
                        }

                        addTransactionCubit.saveTransaction(
                          amount: amountText,
                          transactionType: transactionType.value,
                          category: categoryController.text.trim(),
                          date: selectedDate.value,
                          note: noteController.text.trim(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
