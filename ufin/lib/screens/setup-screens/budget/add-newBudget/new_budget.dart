import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/screens/setup-screens/budget/add-newBudget/slider/budget_slider.dart';
import 'package:ufin/screens/setup-screens/budget/add-newBudget/subtype_budget.dart';

var f = NumberFormat('##,##,###');

class NewBudget extends StatefulWidget {
  const NewBudget(
      {super.key, required this.onAddBudget, required this.userMailId});

  final void Function(Budget budget) onAddBudget;
  final String userMailId;

  @override
  State<NewBudget> createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final _form = GlobalKey<FormState>();

  var budgetTitle = '';
  String perferance = 'In between';
  num amount = 0;
  final List<BudgetSubtype> _budgetSubtypeList = [];

  void _openSubtypeOver() {
    showDialog(
      context: context,
      builder: (context) => SubtypeBudget(onPickSubtype: _addBudgetSubtype),
    );
  }

  void _addBudgetSubtype(BudgetSubtype subtype) {
    setState(() {
      _budgetSubtypeList.add(subtype);
    });
  }

  void removeSubtype(BudgetSubtype subtype) {
    setState(() {
      _budgetSubtypeList.remove(subtype);
    });
  }

  _summitNewBudget() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (_budgetSubtypeList.isNotEmpty) {
      num totalSubBudgetAmount = 0;

      for (int index = 0; index < _budgetSubtypeList.length; index++) {
        totalSubBudgetAmount += _budgetSubtypeList[index].subamount;
      }
      amount = totalSubBudgetAmount;
    }

    var result = {
      for (var index in _budgetSubtypeList) index.subtitle: index.subamount
    };

    _form.currentState!.save();
    widget.onAddBudget(
      Budget(title: budgetTitle, perferance: perferance, amount: amount),
    );
    Navigator.pop(context);

    await FirebaseFirestore.instance
        .collection('usersSubTypeBudget')
        .doc(widget.userMailId)
        .set(
      {
        'userSubBudgetAmount': result,
        'userTotalSubBudget': amount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    num _totalSubBudgetAmount = 0;

    for (int index = 0; index < _budgetSubtypeList.length; index++) {
      _totalSubBudgetAmount += _budgetSubtypeList[index].subamount;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Text(
                  'Give a name to your budget categoy',
                  textAlign: TextAlign.left,
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
                if (_budgetSubtypeList.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Your total amount for this budget',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Container(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '₹ ${f.format(_totalSubBudgetAmount)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 10),
                // Text(
                //   'Would like to add sub-type your budget',
                //   textAlign: TextAlign.left,
                //   style: Theme.of(context).textTheme.titleLarge,
                // ),
                // const SizedBox(height: 15),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Text(
                //         '(For example Food can have \nsub-type of Resturan, Food Delivery)'),
                //     const Spacer(),
                //     ElevatedButton(
                //       onPressed: _openSubtypeOver,
                //       child: const Icon(Icons.add),
                //     )
                //   ],
                // ),
                if (_budgetSubtypeList.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _budgetSubtypeList.length,
                      itemBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Title : ',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    _budgetSubtypeList[index].subtitle,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    'Amount : ',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '₹ ${f.format(_budgetSubtypeList[index].subamount)}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    removeSubtype(_budgetSubtypeList[index]);
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
                if (_budgetSubtypeList.isEmpty)
                  Column(
                    children: [
                      Text(
                        'Enter the amount that you wish you need to spend for this budget',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Enter the amount',
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
                    ],
                  ),
                const SizedBox(height: 15),
                Text(
                  'What is your priority for this budget',
                  style: Theme.of(context).textTheme.titleLarge,
                  //textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}
