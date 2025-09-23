import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/transactions/widgets/styles.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/icon_with_texts.dart';
import '../widgets/amount_rich_text.dart';
import '../widgets/info_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routing/app_routes.dart';
import 'package:mybudget/features/transactions/cubit/add_transaction_cubit.dart';

class TransactionDetailsScreen extends HookWidget {
  final int index;
  const TransactionDetailsScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTransactionCubit(),
      child: _TransactionDetailsContent(index: index),
    );
  }
}

class _TransactionDetailsContent extends HookWidget {
  final int index;
  const _TransactionDetailsContent({required this.index});

  @override
  Widget build(BuildContext context) {
    final isRepeatingPayment = useState(false);

    final box = Hive.box<TransactionModel>('transactions');
    final transaction = box.getAt(index);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
        leadingWidth: 48,
        title: const Text('MyBudget', style: AppTextStyles.title),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/chevron.left.svg',
            color: Colors.white,
            height: 16,
            width: 16,
          ),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconWithTexts(
                    iconPath: 'assets/icons/payy.svg',
                    category: transaction?.category ?? '',
                    transactionType: transaction?.transactionType ?? '',
                  ),
                  const Spacer(),
                  if (transaction != null)
                    AmountRichText(amount: transaction.amount),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InfoBox(
              iconPath: 'assets/icons/calendar.svg',
              text:
                  transaction != null
                      ? '${transaction.date.day.toString().padLeft(2, '0')}.${transaction.date.month.toString().padLeft(2, '0')}.${transaction.date.year}'
                      : 'Nema podataka',
              borderRadius: 0,
            ),
            const SizedBox(height: 24),
            InfoBox(
              iconPath: 'assets/icons/Vector.svg',
              text:
                  (transaction?.note?.isNotEmpty == true)
                      ? transaction!.note!
                      : 'Nema podataka',
              borderRadius: 8,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: GestureDetector(
                onTap: () async {
                  final cubit = context.read<AddTransactionCubit>();
                  await cubit.deleteTransaction(index);

                  if (cubit.state.success) {
                    context.go(AppRoutes.home);
                  } else if (cubit.state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(cubit.state.errorMessage!)),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'Delete transaction',
                      style: AppTextStyles.deleteText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Set as repeating payment',
                      style: AppTextStyles.repeatingPaymentLabel,
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: isRepeatingPayment.value,
                        onChanged: (val) {
                          isRepeatingPayment.value = val;
                        },
                        activeColor: AppColors.appBarColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (transaction != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'MyBudget — smart budgeting made easy\nMyBudget © 2025',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.footerText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
