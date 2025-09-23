import 'repeating_payment.dart';

abstract class RepeatingPaymentsState {}

class RepeatingPaymentsInitial extends RepeatingPaymentsState {}

class RepeatingPaymentsLoaded extends RepeatingPaymentsState {
  final List<RepeatingPayment> payments;

  RepeatingPaymentsLoaded(this.payments);
}
