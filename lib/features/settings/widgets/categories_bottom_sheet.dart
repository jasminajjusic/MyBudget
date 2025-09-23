import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

void showCategoriesBottomSheet(BuildContext context) {
  final cubit = BlocProvider.of<BudgetSettingsCubit>(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: cubit,
        child: BlocBuilder<BudgetSettingsCubit, BudgetSettingsModel?>(
          builder: (context, state) {
            if (state == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final categories = state.categories ?? [];
            return _CategoriesBottomSheetContent(initialCategories: categories);
          },
        ),
      );
    },
  );
}

class _CategoriesBottomSheetContent extends HookWidget {
  final List<String> initialCategories;

  const _CategoriesBottomSheetContent({
    Key? key,
    required this.initialCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = useState<List<String>>([...initialCategories]);
    final selectedCategories = useState<Set<String>>(initialCategories.toSet());
    final newCategoryController = useTextEditingController();

    void addCategory() {
      final newCat = newCategoryController.text.trim();
      if (newCat.isNotEmpty && !categories.value.contains(newCat)) {
        categories.value = [...categories.value, newCat];
        selectedCategories.value = {...selectedCategories.value, newCat};
        newCategoryController.clear();
      }
    }

    void deleteCategory(String category) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Delete category?'),
              content: Text('Are you sure you want to delete "$category"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
      );

      if (confirm == true) {
        categories.value =
            categories.value.where((c) => c != category).toList();
        selectedCategories.value.remove(category);

        final cubit = context.read<BudgetSettingsCubit>();
        final updated = BudgetSettingsModel(
          totalBudget: cubit.totalBudget,
          categories: categories.value,
          limits: cubit.state?.limits,
        );
        await cubit.saveBudgetSettings(updated);

        print('Deleted category: $category');
        print('Remaining categories: ${categories.value}');
      }
    }

    void saveCategories() {
      final cubit = context.read<BudgetSettingsCubit>();
      final updated = BudgetSettingsModel(
        totalBudget: cubit.totalBudget,
        categories: selectedCategories.value.toList(),
        limits: cubit.state?.limits,
      );
      cubit.saveBudgetSettings(updated);

      print('Saved categories: ${selectedCategories.value.toList()}');
      Navigator.pop(context);
    }

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const Center(
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.value.length,
                itemBuilder: (context, index) {
                  final cat = categories.value[index];
                  final isChecked = selectedCategories.value.contains(cat);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      cat,
                      style: const TextStyle(letterSpacing: -0.5),
                    ),
                    trailing: Checkbox(
                      value: isChecked,
                      onChanged: (val) {
                        if (val == null) return;
                        final newSelected = Set<String>.from(
                          selectedCategories.value,
                        );
                        if (val) {
                          newSelected.add(cat);
                        } else {
                          newSelected.remove(cat);
                        }
                        selectedCategories.value = newSelected;
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                        side: const BorderSide(color: Colors.grey, width: 0.6),
                      ),
                      fillColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) =>
                            states.contains(MaterialState.selected)
                                ? const Color(0xFF151822)
                                : null,
                      ),
                      checkColor: Colors.white,
                    ),
                    onTap: () => deleteCategory(cat),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Add new category',
                      labelStyle: const TextStyle(fontSize: 13),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.7,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: addCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151822),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF151822),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
