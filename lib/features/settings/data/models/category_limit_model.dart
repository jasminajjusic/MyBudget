import 'package:hive/hive.dart';

part 'category_limit_model.g.dart';

@HiveType(typeId: 5)
class CategoryLimitModel extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double limit;

  @HiveField(2)
  String period;

  @HiveField(3)
  bool sendNotification;

  CategoryLimitModel({
    required this.category,
    required this.limit,
    required this.period,
    required this.sendNotification,
  });
}
