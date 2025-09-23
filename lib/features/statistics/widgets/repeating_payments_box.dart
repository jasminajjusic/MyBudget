import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/settings/data/models/repeating_payments_state.dart';
import 'package:mybudget/features/settings/data/models/repeating_payment.dart';
import 'package:mybudget/features/settings/cubit/repeating_payments_cubit.dart';

class RepeatingPaymentsBoxWrapper extends StatelessWidget {
  const RepeatingPaymentsBoxWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => RepeatingPaymentsCubit(
            Hive.box<RepeatingPayment>('repeating_payments'),
          )..loadPayments(),
      child: const RepeatingPaymentsBox(),
    );
  }
}

class RepeatingPaymentsBox extends StatelessWidget {
  const RepeatingPaymentsBox({super.key});

  static const Map<String, String> iconMap = {
    'entertainment_1': 'assets/icons/entertainment_1.svg',
    'entertainment_2': 'assets/icons/entertainment_2.svg',
    'entertainment_3': 'assets/icons/entertainment_3.svg',
    'gym_1': 'assets/icons/gym_1.svg',
    'gym_2': 'assets/icons/gym_2.svg',
    'coffee_1': 'assets/icons/coffee_1.svg',
    'netflix': 'assets/icons/netflix.svg',
    'sport': 'assets/icons/sport.svg',
    'shopping_1': 'assets/icons/shopping_1.svg',
    'movie': 'assets/icons/movie.svg',
    'music': 'assets/icons/music.svg',
    'restaurant': 'assets/icons/restaurant.svg',
    'home': 'assets/icons/home.svg',
    'bills': 'assets/icons/bills.svg',
    'calendar': 'assets/icons/calendar.svg',
    'clock': 'assets/icons/clock.svg',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepeatingPaymentsCubit, RepeatingPaymentsState>(
      builder: (context, state) {
        if (state is RepeatingPaymentsLoaded) {
          final payments = state.payments;

          if (payments.isEmpty) {
            return const Center(child: Text('No repeating payments'));
          }

          return Column(
            children:
                payments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final payment = entry.value;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child:
                                  payment.iconKey != null
                                      ? SvgPicture.asset(
                                        iconMap[payment.iconKey] ??
                                            'assets/icons/default.svg',
                                        width: 28,
                                        height: 28,
                                      )
                                      : SvgPicture.asset(
                                        'assets/icons/default.svg',
                                        width: 28,
                                        height: 28,
                                      ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                payment.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade900,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<RepeatingPaymentsCubit>()
                                    .deletePayment(index);
                                debugPrint('Deleted ${payment.name}');
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SVGInfoItem(
                              svgAsset: 'assets/icons/pay.svg',
                              iconColor: Colors.red,

                              label: payment.amount.toStringAsFixed(2),
                            ),
                            const _VerticalDivider(),
                            _SVGInfoItem(
                              svgAsset: 'assets/icons/calendarr.svg',
                              label:
                                  '${payment.dateTime.day}/${payment.dateTime.month}/${payment.dateTime.year}',
                              iconColor: Colors.black,
                              textColor: Colors.grey.shade700,
                            ),
                            const _VerticalDivider(),
                            _SVGInfoItem(
                              svgAsset: 'assets/icons/clock.svg',
                              label:
                                  '${payment.dateTime.hour.toString().padLeft(2, '0')}:${payment.dateTime.minute.toString().padLeft(2, '0')}',
                              iconColor: Colors.green.shade400,
                              textColor: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
          );
        } else if (state is RepeatingPaymentsInitial) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 28, width: 1, color: Colors.grey.shade300);
  }
}

class _SVGInfoItem extends StatelessWidget {
  final String svgAsset;
  final String label;
  final Color iconColor;
  final Color textColor;

  const _SVGInfoItem({
    super.key,
    required this.svgAsset,
    required this.label,
    this.iconColor = Colors.grey,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          svgAsset,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
