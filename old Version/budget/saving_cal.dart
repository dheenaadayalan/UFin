import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufin/screens/setup-screens/budget/budget_info.dart';

var f = NumberFormat('##,##,###');

class SavingCal extends StatefulWidget {
  const SavingCal(
      {super.key, required this.balanceBuget, required this.userMailId});

  final String userMailId;
  final int balanceBuget;

  @override
  State<SavingCal> createState() => _SavingCalState();
}

class _SavingCalState extends State<SavingCal> {
  double _currentSliderValue = 20;

  void summit() async {
    final savingAmount = (widget.balanceBuget * _currentSliderValue) / 100;
    final balanceToBudget = widget.balanceBuget -
        ((widget.balanceBuget * _currentSliderValue) / 100);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BudgetScreen(
            userMailId: widget.userMailId, balanceBuget: balanceToBudget),
      ),
    );

    await FirebaseFirestore.instance
        .collection('users Saving Amount')
        .doc(widget.userMailId)
        .set(
      {
        'saving Amount': savingAmount,
        'balance to budget': balanceToBudget,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Now lets Budget you Income',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 20),
              Text(
                'Set a Percent of your Income that you wish to save every month',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'Amount remaining after you all Monthly Commitments',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹ ${f.format(widget.balanceBuget)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'Amount you wish to save',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹ ${f.format((widget.balanceBuget * _currentSliderValue) / 100)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'Balance Amount to budget',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹ ${f.format(widget.balanceBuget - ((widget.balanceBuget * _currentSliderValue) / 100))}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RBI recomends saving 20% of your Income is best pratices',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              Slider(
                value: _currentSliderValue,
                max: 50,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: summit,
                child: const Text('Summit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
