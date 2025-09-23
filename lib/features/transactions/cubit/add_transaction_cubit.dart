import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';
import 'package:mybudget/features/transactions/state/add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit() : super(AddTransactionState.initial()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final transactionsBox = Hive.box<TransactionModel>('transactions');
      final List<TransactionModel> all = transactionsBox.values.toList();
      emit(state.copyWith(transactions: all));
    } catch (e) {}
  }

  Future<void> saveTransaction({
    required String amount,
    required String transactionType,
    required String category,
    required DateTime date,
    required String note,
  }) async {
    emit(state.copyWith(isSaving: true, success: false, errorMessage: null));

    try {
      final transactionsBox = Hive.box<TransactionModel>('transactions');
      final budgetBox = Hive.box<BudgetSettingsModel>('budget_settings');

      final double parsedAmount = double.parse(amount);

      final transaction = TransactionModel(
        amount: parsedAmount,
        transactionType: transactionType,
        category: category,
        date: date,
        note: note,
      );

      await transactionsBox.add(transaction);

      final all = transactionsBox.values.toList();
      emit(state.copyWith(transactions: all));

      BudgetSettingsModel? budgetSettings = budgetBox.get('settings');
      if (budgetSettings == null) {
        budgetSettings = BudgetSettingsModel(totalBudget: 0.0);
      }

      double updatedBudget = budgetSettings.totalBudget;
      if (transactionType.toLowerCase() == 'income') {
        updatedBudget += parsedAmount;
      } else if (transactionType.toLowerCase() == 'expense') {
        updatedBudget -= parsedAmount;
      }

      final updatedSettings = BudgetSettingsModel(
        totalBudget: updatedBudget,
        categories: budgetSettings.categories,
      );
      await budgetBox.put('settings', updatedSettings);

      emit(state.copyWith(isSaving: false, success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          success: false,
          errorMessage: 'Failed to save transaction: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> deleteTransaction(int index) async {
    emit(state.copyWith(isSaving: true, success: false, errorMessage: null));

    try {
      final transactionsBox = Hive.box<TransactionModel>('transactions');
      final budgetBox = Hive.box<BudgetSettingsModel>('budget_settings');

      final transaction = transactionsBox.getAt(index);
      if (transaction == null) {
        emit(
          state.copyWith(
            isSaving: false,
            success: false,
            errorMessage: 'Transaction not found.',
          ),
        );
        return;
      }

      final double amount = transaction.amount;
      final String transactionType = transaction.transactionType.toLowerCase();

      await transactionsBox.deleteAt(index);

      final all = transactionsBox.values.toList();
      emit(state.copyWith(transactions: all));

      BudgetSettingsModel? budgetSettings = budgetBox.get('settings');
      if (budgetSettings == null) {
        budgetSettings = BudgetSettingsModel(totalBudget: 0.0);
      }

      double updatedBudget = budgetSettings.totalBudget;
      if (transactionType == 'income') {
        updatedBudget -= amount;
      } else if (transactionType == 'expense') {
        updatedBudget += amount;
      }

      final updatedSettings = BudgetSettingsModel(
        totalBudget: updatedBudget,
        categories: budgetSettings.categories,
      );

      await budgetBox.put('settings', updatedSettings);

      emit(state.copyWith(isSaving: false, success: true));
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          success: false,
          errorMessage: 'Failed to delete transaction: ${e.toString()}',
        ),
      );
    }
  }
}
