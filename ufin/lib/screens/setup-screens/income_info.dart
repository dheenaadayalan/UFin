import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/setup-screens/commitment/commit_welcom.dart';

var f = NumberFormat('##,##,###');

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key, required this.userMailId});

  final String userMailId;

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _form = GlobalKey<FormState>();

  var _salaryIncome = 0;
  var _businessIncome = 0;
  var _investmentIncome = 0;
  var _otherIncome = 0;

  int salaryValue = 0;
  int businessValue = 0;
  int investimentValue = 0;
  int otherValue = 0;

  save() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    final totalIncome =
        salaryValue + businessValue + investimentValue + otherValue;
    _form.currentState!.save();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommitWelcome(
          userMailId: widget.userMailId, totalIncome: totalIncome),
    ));

    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(widget.userMailId)
        .set(
      {
        'salary Income': _salaryIncome,
        'business Income': _businessIncome,
        'investment Income': _investmentIncome,
        'other Income': _otherIncome,
        'total Incom': totalIncome,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight / 2,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight / 2,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Card(
                  child: Form(
                    key: _form,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            'Enter your Total Income for a month',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Your total Income for a month ₹${f.format(salaryValue + businessValue + investimentValue + otherValue)} ',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  salaryValue = 0;
                                });
                              } else {
                                setState(() {
                                  salaryValue = int.parse(value);
                                });
                              }
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Salary Income'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter 0 if Income from this income type is nothing';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _salaryIncome = int.parse(newValue!);
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  businessValue = 0;
                                });
                              } else {
                                setState(() {
                                  businessValue = int.parse(value);
                                });
                              }
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Bussiness Income'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter 0 if Income from this income type is nothing';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _businessIncome = int.parse(newValue!);
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  investimentValue = 0;
                                });
                              } else {
                                setState(() {
                                  investimentValue = int.parse(value);
                                });
                              }
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Investment Income'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter 0 if Income from this income type is nothing';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _investmentIncome = int.parse(newValue!);
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  otherValue = 0;
                                });
                              } else {
                                setState(() {
                                  otherValue = int.parse(value);
                                });
                              }
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    'Other Income like Income from Parents'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter 0 if Income from this income type is nothing';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _otherIncome = int.parse(newValue!);
                            },
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            onPressed: save,
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
