import 'package:hive/hive.dart';

part 'repeating_payment.g.dart';

@HiveType(typeId: 8)
class RepeatingPayment extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String iconKey;

  RepeatingPayment({
    required this.name,
    required this.dateTime,
    required this.amount,
    required this.iconKey,
  });
}
