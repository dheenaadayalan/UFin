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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IncomeEdit(
                            userMailId: widget.userMailId,
                          ),
                        ));
                      },
                      child: const Text('Edit'),
                    )
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        if (snapshot.hasData)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '₹ ${f.format(snapshot.data!['salary Income']).toString()}',
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
                        if (snapshot.hasData)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '₹ ${f.format(snapshot.data!['business Income']).toString()}',
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
                        if (snapshot.hasData)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '₹ ${f.format(snapshot.data!['investment Income']).toString()}',
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
                        if (snapshot.hasData)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '₹ ${f.format(snapshot.data!['other Income']).toString()}', // '₹ ${}'
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
        );
      },
    );
  }
}
