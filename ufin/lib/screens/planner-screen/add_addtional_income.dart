import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufin/screens/home_tabs.dart';

var f = NumberFormat('##,##,###');
var formatterDay = DateFormat('d');

class AddtionalIncome extends StatefulWidget {
  const AddtionalIncome({super.key});

  @override
  State<AddtionalIncome> createState() => _AddtionalIncomeState();
}

class _AddtionalIncomeState extends State<AddtionalIncome> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final _form = GlobalKey<FormState>();
  num salaryIncome = 0;
  num businessIncome = 0;
  num investmentIncome = 0;
  num otherIncome = 0;
  num addtionalIncome = 0;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        salaryIncome = doc['salary Income'];
        businessIncome = doc['business Income'];
        investmentIncome = doc['investment Income'];
        otherIncome = doc['other Income'];
      });
    });
  }

  save() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    final totalIncome = salaryIncome +
        businessIncome +
        investmentIncome +
        otherIncome +
        addtionalIncome;

    _form.currentState!.save();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
      (Route route) => false,
    );

    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(userEmail)
        .update(
      {
        'total Incom': totalIncome,
        'addtional Incom': addtionalIncome,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Monthly Income',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 200,
                              width: 180,
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.money, size: 80),
                                      Text(
                                        'Salary Income',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        //'₹ ${f.format(salaryIncome)}',
                                        '₹ ${f.format(salaryIncome).toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 200,
                              width: 180,
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.business, size: 80),
                                      Text(
                                        'Business Income',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        //'₹ ${f.format(businessIncome)}',
                                        '₹ ${f.format(businessIncome).toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 200,
                              width: 180,
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.bar_chart, size: 80),
                                      Text(
                                        'Investment Income',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        //'₹ ${f.format(investmentIncome)}',
                                        '₹ ${f.format(investmentIncome).toString()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 200,
                              width: 180,
                              padding: const EdgeInsets.all(5),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.pie_chart_outline_sharp,
                                          size: 80),
                                      Text(
                                        'Other Income',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        //'₹ ${f.format(otherIncome)}',
                                        '₹ ${f.format(otherIncome).toString()}', // '₹ ${}'
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Do you like to add or reduce Income only for this month?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You can add those kinds of Income below every month',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _form,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            addtionalIncome = 0;
                          });
                        } else {
                          setState(() {
                            addtionalIncome = int.parse(value);
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Addtional Income',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter 0 if Income from this income type is nothing';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        addtionalIncome = int.parse(newValue!);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: save,
                    child: const Text('Save'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
