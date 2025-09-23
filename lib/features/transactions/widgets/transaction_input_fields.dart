import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:mybudget/features/settings/data/models/budget_settings_model.dart';

class TransactionInputFields extends HookWidget {
  final TextEditingController amountController;
  final TextEditingController categoryController;
  final TextEditingController noteController;
  final ValueNotifier<DateTime> selectedDate;
  final ValueNotifier<String> transactionType;

  const TransactionInputFields({
    super.key,
    required this.amountController,
    required this.categoryController,
    required this.noteController,
    required this.selectedDate,
    required this.transactionType,
  });

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFE1E1E1), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF151822),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) selectedDate.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    final categories = useState<List<String>>([]);

    useEffect(() {
      Future<void> loadCategories() async {
        final box = await Hive.openBox<BudgetSettingsModel>('budget_settings');

        final settings = box.get('settings');
        categories.value = settings?.categories ?? [];
      }

      loadCategories();
      return null;
    }, []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Amount'),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Enter amount'),
          style: const TextStyle(height: 1.2),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        _buildLabel('Transaction Type'),
        DropdownButtonFormField<String>(
          value: transactionType.value,
          decoration: _inputDecoration('Select type'),
          items: const [
            DropdownMenuItem(
              value: 'Income',
              child: Text('Income', style: TextStyle(color: Colors.black)),
            ),
            DropdownMenuItem(
              value: 'Expense',
              child: Text('Expense', style: TextStyle(color: Colors.black)),
            ),
          ],
          onChanged: (value) {
            if (value != null) transactionType.value = value;
          },
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.grey[700],
        ),
        const SizedBox(height: 12),
        _buildLabel('Category'),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: _inputDecoration('Select category'),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
                menuMaxHeight: 250,
                value:
                    categoryController.text.isNotEmpty
                        ? categoryController.text
                        : (categories.value.isNotEmpty
                            ? categories.value.first
                            : null),
                items:
                    categories.value.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) categoryController.text = value;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildLabel('Date'),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: _inputDecoration(
                DateFormat.yMMMd().format(selectedDate.value),
              ),
              controller: TextEditingController(
                text: DateFormat.yMMMd().format(selectedDate.value),
              ),
              style: const TextStyle(height: 1.2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLabel('Note (optional)'),
        TextField(
          controller: noteController,
          decoration: _inputDecoration('Enter note'),
          style: const TextStyle(height: 1.2),
        ),
      ],
    );
  }
}
