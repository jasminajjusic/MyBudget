import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String transactionType;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String note;

  TransactionModel({
    required this.amount,
    required this.transactionType,
    required this.category,
    required this.date,
    required this.note,
  });
}
