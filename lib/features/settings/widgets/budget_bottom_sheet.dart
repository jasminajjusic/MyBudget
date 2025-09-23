import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';

void showBudgetBottomSheet(BuildContext context) {
  final TextEditingController budgetController = TextEditingController();

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bottomSheetContext) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withOpacity(0)),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: MediaQuery.of(bottomSheetContext).viewInsets,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                  ),
                ),
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
                              onTap: () => Navigator.pop(bottomSheetContext),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Set your budget',
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
                        children: [
                          TextField(
                            controller: budgetController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Monthly Budget',
                              labelStyle: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFB0B0B0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final value = double.tryParse(
                                  budgetController.text,
                                );
                                if (value != null) {
                                  context
                                      .read<BudgetSettingsCubit>()
                                      .updateBudget(value)
                                      .then((_) {
                                        final updatedBudget =
                                            context
                                                .read<BudgetSettingsCubit>()
                                                .totalBudget;
                                        print('Updated budget: $updatedBudget');
                                      });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Budget successfully updated!',
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(bottomSheetContext);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid number!',
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF151822),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
              ),
            ),
          ),
        ],
      );
    },
  );
}
