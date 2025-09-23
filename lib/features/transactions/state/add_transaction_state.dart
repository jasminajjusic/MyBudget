import 'package:equatable/equatable.dart';
import 'package:mybudget/features/transactions/data/models/transaction_model.dart';

class AddTransactionState extends Equatable {
  final bool isSaving;
  final bool success;
  final String? errorMessage;
  final List<TransactionModel> transactions;

  const AddTransactionState({
    required this.isSaving,
    required this.success,
    this.errorMessage,
    required this.transactions,
  });

  factory AddTransactionState.initial() {
    return const AddTransactionState(
      isSaving: false,
      success: false,
      errorMessage: null,
      transactions: [],
    );
  }

  AddTransactionState copyWith({
    bool? isSaving,
    bool? success,
    String? errorMessage,
    List<TransactionModel>? transactions,
  }) {
    return AddTransactionState(
      isSaving: isSaving ?? this.isSaving,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [isSaving, success, errorMessage, transactions];
}
