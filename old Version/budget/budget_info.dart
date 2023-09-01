import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/screens/home_tabs.dart';
import 'package:ufin/screens/setup-screens/budget/new_budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen(
      {super.key, required this.userMailId, required this.balanceBuget});

  final String userMailId;
  final num balanceBuget;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final List<Budget> _budget = [];
  void _openAddBudgetOverlay() {
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewBudget(onAddBudget: _addBudget),
    );
  }

  void _addBudget(Budget budget) {
    setState(() {
      _budget.add(budget);
    });
  }

  void _removeBudget(Budget budget) {
    setState(() {
      _budget.remove(budget);
    });
  }

  void saveBudget() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
    );

    var result = {for (var index in _budget) index.title: index.perferance};

    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(widget.userMailId)
        .set(
      {
        'userBudget': result,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'No Budget found. Start adding some!, By clicking the "+" button above.',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
    if (_budget.isNotEmpty) {
      mainContent = Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Living',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.balanceBuget}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Your list of budget'),
                const Spacer(),
                ElevatedButton(
                  onPressed: saveBudget,
                  child: const Text('Save'),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(_budget[index].title),
                        const Spacer(),
                        Text(_budget[index].perferance.toString()),
                        const Spacer(),
                        Text(_budget[index].amount.toString()),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _removeBudget(_budget[index]);
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: _budget.length,
              ),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
        actions: [
          IconButton(
            onPressed: _openAddBudgetOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: mainContent,
    );
  }
}
