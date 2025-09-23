import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/models/budget_settings_model.dart';
import '../data/models/category_limit_model.dart';

class BudgetSettingsCubit extends Cubit<BudgetSettingsModel?> {
  final String _boxName = 'budget_settings';

  BudgetSettingsCubit()
    : super(BudgetSettingsModel(totalBudget: 0, categories: [])) {
    loadBudgetSettings();
  }

  Future<void> loadBudgetSettings() async {
    final box = await Hive.openBox<BudgetSettingsModel>(_boxName);
    final settings = box.get('settings');
    if (settings != null) {
      emit(settings);
    } else {
      emit(BudgetSettingsModel(totalBudget: 0, categories: []));
    }
  }

  Future<void> saveBudgetSettings(BudgetSettingsModel settings) async {
    final box = await Hive.openBox<BudgetSettingsModel>(_boxName);
    await box.put('settings', settings);
    emit(settings);
  }

  Future<void> updateBudget(double newBudget) async {
    final currentCategories = state?.categories ?? [];
    final updated = BudgetSettingsModel(
      totalBudget: newBudget,
      categories: currentCategories,
    );
    await saveBudgetSettings(updated);
  }

  Future<void> addCategory(String category) async {
    final List<String> updatedCategories = [...state!.categories, category];

    final updated = BudgetSettingsModel(
      totalBudget: state?.totalBudget ?? 0,
      categories: updatedCategories,
    );
    await saveBudgetSettings(updated);
  }

  Future<void> removeCategory(String category) async {
    final List<String> updatedCategories = [...state!.categories, category];

    final updated = BudgetSettingsModel(
      totalBudget: state?.totalBudget ?? 0,
      categories: updatedCategories,
    );
    await saveBudgetSettings(updated);
  }

  Future<void> addCategoryLimit(CategoryLimitModel limit) async {
    final current = state;
    if (current == null) return;

    final updatedLimits = List<CategoryLimitModel>.from(current.limits ?? []);

    final index = updatedLimits.indexWhere((l) => l.category == limit.category);
    if (index != -1) {
      updatedLimits[index] = limit;
    } else {
      updatedLimits.add(limit);
    }

    final updated = BudgetSettingsModel(
      totalBudget: current.totalBudget,
      categories: current.categories,
      limits: updatedLimits,
    );

    await saveBudgetSettings(updated);

    final box = await Hive.openBox<CategoryLimitModel>('category_limits');

    final existingKey = box.keys.firstWhere(
      (key) => box.get(key)!.category == limit.category,
      orElse: () => null,
    );

    if (existingKey != null) {
      await box.put(existingKey, limit);
    } else {
      await box.add(limit);
    }

    emit(updated);
  }

  double get totalBudget => state?.totalBudget ?? 0.0;
}
