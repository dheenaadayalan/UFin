//
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/setup-screens/budget/add-newBudget/new_budget.dart';

var f = NumberFormat('##,##,###');

class BudgetEdit extends StatefulWidget {
  const BudgetEdit(
      {super.key, required this.userMailId, required this.userexstingExpences});

  final String userMailId;
  final List<BudgetTotalExp> userexstingExpences;

  @override
  State<BudgetEdit> createState() => _BudgetEditState();
}

class _BudgetEditState extends State<BudgetEdit> {
  List<Budget> _budget = [];
  num balanceBuget = 0;

  @override
  void initState() {
    initialize();
    initialize1();
    super.initState();
  }

  void initialize() async {
    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(widget.userMailId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        List budgetMap = doc['budget type'];
        setState(() {
          _budget = convertListOfMapsToList(budgetMap);
        });

        //print(budgetMap);
      },
    );
  }

  void initialize1() async {
    await FirebaseFirestore.instance
        .collection('users Saving Amount')
        .doc(widget.userMailId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        balanceBuget = doc['balance to budget'];
        print(balanceBuget);
      },
    );
  }

  List<Budget> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return Budget(
        title: listOfMaps[index]['title'],
        perferance: listOfMaps[index]['perferance type'],
        amount: listOfMaps[index]['amount'],
      );
    });
  }

  void _openAddBudgetOverlay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NewBudget(onAddBudget: _addBudget, userMailId: widget.userMailId),
      ),
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
    Navigator.of(context).pop();

    num totalBudgetAmount = 0;
    for (int index = 0; index < _budget.length; index++) {
      totalBudgetAmount += _budget[index].amount;
    }

    List<Map<String, Object>> data = [
      for (var index in _budget)
        {
          'title': index.title,
          'amount': index.amount,
          'perferance type': index.perferance,
        }
    ];

    List<Map<String, Object>> data1 = [
          for (var index in _budget)
            {
              'Budget': index.title,
              'Amount': 0,
              'Date': DateTime.now(),
            }
        ] +
        [
          for (var index in widget.userexstingExpences)
            {
              'Budget': index.newBudgetType,
              'Amount': index.amount,
              //'Date': DateTime.now(),
            }
        ];

    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(widget.userMailId)
        .set(
      {
        'budget type': data,
        'userTotalBudget': totalBudgetAmount,
      },
    );

    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(widget.userMailId)
        .set({
      'Current Expences data': data1,
    });
  }

  @override
  Widget build(BuildContext context) {
    num _totalBudgetAmount = 0;
    for (int index = 0; index < _budget.length; index++) {
      _totalBudgetAmount += _budget[index].amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              children: [
                Card(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Balance to Budget\nafter Savings',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '₹ ${f.format((balanceBuget - _totalBudgetAmount))}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Card(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  margin: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total budget Amount',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '₹ ${f.format(_totalBudgetAmount)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Your list of budget'),
                const Spacer(),
                ElevatedButton(
                  onPressed: _openAddBudgetOverlay,
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Item',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    'Perferance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    'Delete',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: _budget.length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                    child: Row(
                      children: [
                        Text(_budget[index].title),
                        const Spacer(),
                        Text(_budget[index].perferance.toString()),
                        const Spacer(),
                        Text('₹ ${f.format(_budget[index].amount).toString()}'),
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
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveBudget,
        label: const Text('Save'),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.green[400],
      ),
    );
  }
}
