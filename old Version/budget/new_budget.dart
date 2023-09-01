import 'package:flutter/material.dart';
import 'package:ufin/models/budget_model.dart';

import 'package:ufin/screens/setup-screens/budget/slider/budget_slider.dart';

class NewBudget extends StatefulWidget {
  const NewBudget({super.key, required this.onAddBudget});

  final void Function(Budget budget) onAddBudget;

  @override
  State<NewBudget> createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final _form = GlobalKey<FormState>();

  var budgetTitle = '';
  double perferance = 50;
  int amount = 0;

  _summitNewBudget() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    widget.onAddBudget(
      Budget(title: budgetTitle, perferance: perferance, amount: amount),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 68, 16, 16),
      child: Form(
        key: _form,
        child: Column(
          children: [
            Text(
              'Add a budget categoy to categories your expences',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title of the Budget',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              maxLength: 20,
              validator: (value) {
                if (value == null) {
                  return 'Enter a name for your budget';
                }
                return null;
              },
              onSaved: (newValue) {
                budgetTitle = newValue!;
              },
            ),
            Text(
              'Enter the amount that you wish you need to spend for this budget',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount for the Budget',
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
                amount = int.parse(newValue!);
              },
            ),
            const SizedBox(height: 15),
            Text(
              'On what % this budget is important for you',
              style: Theme.of(context).textTheme.titleLarge,
              //textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              '(100% bening the most important and 0% being least important)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            BudgetSlider(
              onAddPerferValue: (perferValue) {
                perferance = perferValue;
              },
            ),
            const SizedBox(height: 20),
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
                  onPressed: _summitNewBudget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
