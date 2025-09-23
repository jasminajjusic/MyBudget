import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/models/repeating_payment.dart';
import '../data/models/repeating_payments_state.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class RepeatingPaymentsCubit extends Cubit<RepeatingPaymentsState> {
  final Box<RepeatingPayment> _box;

  RepeatingPaymentsCubit(this._box) : super(RepeatingPaymentsInitial());

  void loadPayments() {
    final payments = _box.values.toList();
    emit(RepeatingPaymentsLoaded(payments));
  }

  Future<void> addPayment(RepeatingPayment payment) async {
    await _box.add(payment);
    loadPayments();
  }

  Future<void> deletePayment(int index) async {
    await _box.deleteAt(index);
    loadPayments();
  }

  Future<void> processDuePayments() async {
    final today = DateTime.now();

    for (var payment in _box.values) {
      final scheduled = payment.dateTime;

      final isSameDay =
          scheduled.day == today.day &&
          scheduled.month == today.month &&
          scheduled.year == today.year;

      if (isSameDay) {
        final transactionsBox = Hive.box<TransactionModel>('transactions');

        final newTransaction = TransactionModel(
          amount: payment.amount,
          transactionType: 'expense',
          category: payment.name,
          date: DateTime.now(),
          note: 'Auto-generated from repeating payment',
        );

        await transactionsBox.add(newTransaction);

        final budgetBox = Hive.box<BudgetSettingsModel>('budget_settings');
        BudgetSettingsModel? settings = budgetBox.get('settings');
        settings ??= BudgetSettingsModel(totalBudget: 0.0);

        final updatedBudget = settings.totalBudget - payment.amount;
        final updatedSettings = BudgetSettingsModel(
          totalBudget: updatedBudget,
          categories: settings.categories,
        );

        await budgetBox.put('settings', updatedSettings);
      }
    }

    loadPayments();
  }
}
