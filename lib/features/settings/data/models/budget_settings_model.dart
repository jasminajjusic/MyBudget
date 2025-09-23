import 'package:hive/hive.dart';
import 'category_limit_model.dart';
part 'budget_settings_model.g.dart';

@HiveType(typeId: 1)
class BudgetSettingsModel extends HiveObject {
  @HiveField(0)
  double totalBudget;

  @HiveField(1)
  List<String> categories;

  @HiveField(2)
  List<CategoryLimitModel>? _limits;

  BudgetSettingsModel({
    required this.totalBudget,
    List<String>? categories,
    List<CategoryLimitModel>? limits,
  }) : categories = categories ?? [],
       _limits = limits;

  List<CategoryLimitModel> get limits => _limits ?? [];
  set limits(List<CategoryLimitModel> value) => _limits = value;
}
