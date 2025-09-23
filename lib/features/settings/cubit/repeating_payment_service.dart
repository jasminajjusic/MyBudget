import 'dart:async';
import 'package:flutter/widgets.dart';

import 'package:mybudget/features/settings/cubit/repeating_payments_cubit.dart';

class RepeatingPaymentService with WidgetsBindingObserver {
  Timer? _timer;
  final RepeatingPaymentsCubit cubit;

  RepeatingPaymentService(this.cubit);

  void start() {
    WidgetsBinding.instance.addObserver(this);

    cubit.processDuePayments();

    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      cubit.processDuePayments();
    });
  }

  void stop() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cubit.processDuePayments();
    }
  }
}
