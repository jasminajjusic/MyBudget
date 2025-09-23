import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 2)
class GoalModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double targetAmount;

  @HiveField(4)
  double currentAmount;

  @HiveField(5)
  DateTime deadline;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  String priority;

  GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,

    required this.isCompleted,
    required this.createdAt,
    required this.priority,
  });
}
