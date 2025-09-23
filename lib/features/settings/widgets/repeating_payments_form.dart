import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybudget/features/settings/widgets/sheet_header.dart';
import 'package:mybudget/features/settings/widgets/date_field.dart';
import 'package:mybudget/features/settings/widgets/time_field.dart';
import 'package:mybudget/features/settings/widgets/name_field.dart';
import 'package:mybudget/features/settings/widgets/save_button.dart';
import 'package:mybudget/features/settings/widgets/icon_picker.dart';
import 'package:mybudget/features/settings/data/models/repeating_payment.dart';
import 'package:mybudget/features/settings/cubit/repeating_payments_cubit.dart';

class RepeatingPaymentsForm extends HookWidget {
  const RepeatingPaymentsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final amountController = useTextEditingController();

    final selectedDate = useState<DateTime?>(null);
    final selectedTime = useState<TimeOfDay?>(null);
    final selectedIconKey = useState<String?>(null);

    void save() async {
      final name = nameController.text.trim();
      final amountText = amountController.text.trim();
      final amount = double.tryParse(amountText);

      if (name.isEmpty ||
          selectedDate.value == null ||
          selectedTime.value == null ||
          amount == null ||
          selectedIconKey.value == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
        return;
      }

      final combinedDateTime = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
        selectedTime.value!.hour,
        selectedTime.value!.minute,
      );

      final payment = RepeatingPayment(
        name: name,
        dateTime: combinedDateTime,
        amount: amount,
        iconKey: selectedIconKey.value!,
      );

      final cubit = context.read<RepeatingPaymentsCubit>();
      await cubit.addPayment(payment);

      Navigator.pop(context);
    }

    Future<void> pickTime() async {
      final now = TimeOfDay.now();
      final picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value ?? now,
      );
      if (picked != null) selectedTime.value = picked;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SheetHeader(title: "Repeating Payment"),
          const SizedBox(height: 16),
          NameField(controller: nameController),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DateField(
                  selectedDate: selectedDate,
                  onPickDate: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value ?? now,
                      firstDate: DateTime(now.year - 5),
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TimeField(
                  selectedTime: selectedTime,
                  onPickTime: pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IconPicker(selectedIconKey: selectedIconKey),
          const SizedBox(height: 24),

          Text(
            "This payment will be repeated monthly starting from the selected date and time.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          SaveButton(onPressed: save),
        ],
      ),
    );
  }
}
