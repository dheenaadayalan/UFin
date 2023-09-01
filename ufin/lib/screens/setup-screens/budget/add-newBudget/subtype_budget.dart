import 'package:flutter/material.dart';
import 'package:ufin/models/budget_model.dart';

class SubtypeBudget extends StatefulWidget {
  const SubtypeBudget({super.key, required this.onPickSubtype});

  final void Function(BudgetSubtype pickedSubtype) onPickSubtype;

  @override
  State<SubtypeBudget> createState() => _SubtypeBudgetState();
}

class _SubtypeBudgetState extends State<SubtypeBudget> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String subtypeList = '';
    num subtypeAmount = 0;

    void saveSubtype() {
      final isValid = _form.currentState!.validate();

      if (!isValid) {
        return;
      }
      _form.currentState!.save();
      widget.onPickSubtype(
        BudgetSubtype(subtitle: subtypeList, subamount: subtypeAmount),
      );
      Navigator.pop(context);
    }

    return AlertDialog(
      content: Stack(
        children: [
          SizedBox(
            height: 200,
            child: Column(
              children: [
                Text(
                  'Name of your Sub-Type',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null) {
                            return 'Enter a proper amount budget';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          subtypeList = newValue!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null) {
                            return 'Enter a proper amount budget';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          subtypeAmount = int.parse(newValue!);
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: saveSubtype,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
