import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'period_selector_box.dart';
import 'custom_text_row.dart';
import 'custom_amount_row.dart';
import 'package:mybudget/features/transactions/state/add_transaction_state.dart';
import 'package:mybudget/features/transactions/cubit/add_transaction_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsChart extends StatelessWidget {
  final String selectedType;
  final String selectedPeriod;
  final void Function(String) onPeriodChanged;

  const StatisticsChart({
    super.key,
    required this.selectedType,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        final transactions = state.transactions;

        final filteredTransactions =
            transactions
                .where((tx) => tx.transactionType.toLowerCase() == selectedType)
                .toList();

        final now = DateTime.now();

        List<FlSpot> spots = [];
        List<String> dates = [];

        double totalAmount = 0;

        if (selectedPeriod == 'weekly') {
          List<double> dailyAmounts = List.filled(7, 0);

          for (var tx in filteredTransactions) {
            final diff = now.difference(tx.date).inDays;
            if (diff >= 0 && diff < 7) {
              final index = 6 - diff;
              dailyAmounts[index] += tx.amount;
            }
          }
          totalAmount = dailyAmounts.fold(0, (a, b) => a + b);

          spots = List.generate(
            7,
            (index) => FlSpot(index.toDouble(), dailyAmounts[index]),
          );

          dates = List.generate(7, (index) {
            final date = now.subtract(Duration(days: 6 - index));
            return "${date.month}/${date.day}";
          });
        } else if (selectedPeriod == 'monthly') {
          final daysInMonth = now.day;

          List<double> dailyAmounts = List.filled(daysInMonth, 0);

          for (var tx in filteredTransactions) {
            if (tx.date.year == now.year && tx.date.month == now.month) {
              final dayIndex = tx.date.day - 1;
              dailyAmounts[dayIndex] += tx.amount;
            }
          }

          totalAmount = dailyAmounts.fold(0, (a, b) => a + b);

          spots = List.generate(
            daysInMonth,
            (index) => FlSpot(index.toDouble(), dailyAmounts[index]),
          );

          dates = List.generate(daysInMonth, (index) {
            final date = DateTime(now.year, now.month, index + 1);
            return "${date.month}/${date.day}";
          });
        } else if (selectedPeriod == 'yearly') {
          final monthsSoFar = now.month;

          List<double> monthlyAmounts = List.filled(monthsSoFar, 0);

          for (var tx in filteredTransactions) {
            if (tx.date.year == now.year && tx.date.month <= now.month) {
              final index = tx.date.month - 1;
              monthlyAmounts[index] += tx.amount;
            }
          }

          totalAmount = monthlyAmounts.fold(0, (a, b) => a + b);

          spots = List.generate(
            monthsSoFar,
            (index) => FlSpot(index.toDouble(), monthlyAmounts[index]),
          );

          dates = List.generate(monthsSoFar, (index) {
            final date = DateTime(now.year, index + 1);
            return "${date.month}/${date.year % 100}";
          });
        }

        final formattedTotalAmount = totalAmount.toStringAsFixed(2);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextRow(
                text:
                    selectedType == 'income'
                        ? "Total Income"
                        : "Total Spendings",
                isGrey: true,
                verticalPadding: 8,
              ),
              CustomAmountRow(
                currency: "KM",
                mainAmount: formattedTotalAmount.split('.')[0],
                decimals: "." + formattedTotalAmount.split('.')[1],
              ),
              const CustomTextRow(
                text: "Overview",
                isGrey: true,
                verticalPadding: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dates.isNotEmpty
                          ? "${_formatDate(dates.first)} - ${_formatDate(dates.last)}"
                          : "",
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                    ),

                    PeriodSelectorBox(
                      selectedPeriod: selectedPeriod,
                      onPeriodChanged: onPeriodChanged,
                    ),
                  ],
                ),
              ),

              const Divider(
                thickness: 0.7,
                height: 0,
                color: Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 32, top: 0),
                child: SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < dates.length) {
                                return Text(
                                  dates[index],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color:
                              selectedType == 'income'
                                  ? Colors.blue
                                  : Colors.red,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length < 2) return '';
      final monthNum = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      const months = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return "${months[monthNum]} $day";
    } catch (e) {
      return '';
    }
  }
}
