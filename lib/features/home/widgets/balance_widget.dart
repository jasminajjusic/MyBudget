import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybudget/features/settings/cubit/budget_settings_cubit.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetSettingsCubit, BudgetSettingsModel?>(
      builder: (context, state) {
        final double balance = state?.totalBudget ?? 0.0;

        String balanceStr = balance.toStringAsFixed(2);
        List<String> parts = balanceStr.split('.');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'KM',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    TextSpan(
                      text: parts[0],
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: '.${parts[1]}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
