import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/setting-screens/income/income_edit.dart';

var f = NumberFormat('##,##,###');

class IncomeSetting extends StatefulWidget {
  const IncomeSetting({super.key, required this.userMailId});

  final String userMailId;

  @override
  State<IncomeSetting> createState() => _IncomeSettingState();
}

class _IncomeSettingState extends State<IncomeSetting> {
  int totalIncome = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('usersIncomeData')
          .doc(widget.userMailId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) const Text('Wlcome');

        return Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Monthly Income',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IncomeEdit(
                            userMailId: widget.userMailId,
                          ),
                        ));
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        if (snapshot.hasData)
                          Container(
                            height: 100,
                            width: 160,
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Salary Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      //'₹ ${f.format(salaryIncome)}',
                                      '₹ ${f.format(snapshot.data!['salary Income']).toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (snapshot.hasData)
                          Container(
                            height: 100,
                            width: 180,
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Business Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      //'₹ ${f.format(businessIncome)}',
                                      '₹ ${f.format(snapshot.data!['business Income']).toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
                        if (snapshot.hasData)
                          Container(
                            height: 100,
                            width: 160,
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Investment Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      //'₹ ${f.format(investmentIncome)}',
                                      '₹ ${f.format(snapshot.data!['investment Income']).toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        if (snapshot.hasData)
                          Container(
                            height: 100,
                            width: 180,
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Other Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      //'₹ ${f.format(otherIncome)}',
                                      '₹ ${f.format(snapshot.data!['other Income']).toString()}', // '₹ ${}'
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
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
        );
      },
    );
  }
}
