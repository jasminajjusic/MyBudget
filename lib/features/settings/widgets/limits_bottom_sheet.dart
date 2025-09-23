import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';
import 'package:mybudget/features/settings/data/models/category_limit_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mybudget/features/routing/app_routes.dart';

void showLimitsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider(
        create: (_) => BudgetSettingsCubit()..loadBudgetSettings(),
        child: const _LimitsBottomSheetContent(),
      );
    },
  );
}

class _LimitsBottomSheetContent extends HookWidget {
  const _LimitsBottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final limitController = useTextEditingController();
    final periods = ['Monthly', 'Weekly', 'Yearly'];
    final selectedPeriod = useState<String>(periods[0]);
    final sendNotification = useState<bool>(true);
    final selectedCategory = useState<String?>(null);

    const inputPadding = EdgeInsets.symmetric(vertical: 14, horizontal: 12);
    const borderRadius = 8.0;
    const fontSize = 14.0;

    void save() async {
      final category = selectedCategory.value;
      final limitText = limitController.text.trim();

      if (category == null || category.isEmpty || limitText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select category and enter limit'),
          ),
        );
        return;
      }

      final limit = double.tryParse(limitText);
      if (limit == null || limit <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid limit')),
        );
        return;
      }

      final limitModel = CategoryLimitModel(
        category: category,
        limit: limit,
        period: selectedPeriod.value,
        sendNotification: sendNotification.value,
      );

      final cubit = context.read<BudgetSettingsCubit>();
      await cubit.addCategoryLimit(limitModel);

      final allLimits = cubit.state?.limits ?? [];
      print('All Limits:');
      for (var l in allLimits) {
        print(
          'Category: ${l.category}, Limit: ${l.limit}, Period: ${l.period}, Notification: ${l.sendNotification}',
        );
      }

      Navigator.of(context).pop();

      context.go(AppRoutes.settings);
    }

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      isDense: true,
      contentPadding: inputPadding,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.7),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 0.7),
      ),
    );

    return BlocBuilder<BudgetSettingsCubit, BudgetSettingsModel?>(
      builder: (context, state) {
        final categories = state?.categories ?? [];

        if (categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No categories available. Please add categories first.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          );
        }

        if (selectedCategory.value == null) {
          selectedCategory.value = categories.first;
        }

        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                        'Set Category Limit',
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
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFE0E0E0),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory.value,
                      dropdownColor: Colors.white,
                      items:
                          categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) selectedCategory.value = value;
                      },
                      decoration: inputDecoration('Category'),
                      style: const TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: limitController,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration('Limit amount'),
                      style: const TextStyle(fontSize: fontSize),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedPeriod.value,
                      dropdownColor: Colors.white,
                      items:
                          periods
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) selectedPeriod.value = value;
                      },
                      decoration: inputDecoration('Period'),
                      style: const TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF151822),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
