import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/settings/cubit/repeating_payments_cubit.dart';
import 'package:mybudget/features/settings/data/models/repeating_payment.dart';
import 'repeating_payments_form.dart';

void showRepeatingPaymentsBottomSheet(BuildContext context) {
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
        create:
            (_) => RepeatingPaymentsCubit(
              Hive.box<RepeatingPayment>('repeating_payments'),
            ),
        child: const _RepeatingPaymentsBottomSheetContent(),
      );
    },
  );
}

class _RepeatingPaymentsBottomSheetContent extends StatelessWidget {
  const _RepeatingPaymentsBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [RepeatingPaymentsForm()],
        ),
      ),
    );
  }
}
