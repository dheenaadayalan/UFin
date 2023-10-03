import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/payment-screen/payment_screen.dart';

var f = NumberFormat('##,##,###');
var formatterMonth = DateFormat('MM');
var now = DateTime.now();

class PlanerHeader extends StatefulWidget {
  const PlanerHeader({super.key, required this.selectedPageIndex});

  final int selectedPageIndex;

  @override
  State<PlanerHeader> createState() => _HeaderState();
}

class _HeaderState extends State<PlanerHeader> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  num totalExp = 0;
  List data = [];
  List<Commitment> commitmentList = [];
  List<Commitment> commitmentList1 = [];
  List<Commitment> commitmentListMonthHolder = [];
  var now = DateTime.now();
  var formatter = DateFormat('Md');
  var formatterDay = DateFormat('d');
  List<Expences> _newExpences = [];
  bool isPaid = false;
  num assetsCommit = 0;
  num liabilityCommit = 0;
  num balanceBeforeBuget = 0;
  num totalCommit = 0;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    if (userEmail == null) {
      setState(() {});
    }
    if (formatterDay.format(now) == '01') {
      FirebaseFirestore.instance
          .collection('budgetRefactor')
          .doc(userEmail)
          .update(
        {
          'bool': false,
        },
      );
    }

    await FirebaseFirestore.instance
        .collection('users Monthly Commitment')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List commitmentMap = doc['commitemt'];
        assetsCommit = doc['assets commitment'];
        liabilityCommit = doc['lablity commitment'];
        balanceBeforeBuget = doc['balance budget befor saving'];
        totalCommit = doc['total commitments'];
        setState(() {
          commitmentList = convertListOfMapsToListCommitment(commitmentMap);
          commitmentList1 = convertListOfMapsToListCommitment(commitmentMap);
        });
        if (formatterDay.format(now) == '01') {
          for (var i = 0; i < commitmentList1.length; i++) {
            commitmentListMonthHolder.add(
              Commitment(
                title: commitmentList1[i].title,
                amount: commitmentList1[i].amount,
                commitType: commitmentList1[i].commitType,
                date: commitmentList1[i].date,
                commitdatetype: commitmentList1[i].commitdatetype,
                paidStatus: false,
              ),
            );

            List<Map<String, Object>> data1 = [
              for (var i in commitmentListMonthHolder)
                {
                  'amount': i.amount,
                  'date': i.date,
                  'bool': i.paidStatus,
                  'commitDateType': i.commitdatetype,
                  'title': i.title,
                  'type': i.commitType,
                }
            ];
            FirebaseFirestore.instance
                .collection("users Monthly Commitment")
                .doc(userEmail)
                .set({
              'commitemt': data1,
              'assets commitment': assetsCommit,
              'lablity commitment': liabilityCommit,
              'balance budget befor saving': balanceBeforeBuget,
              'total commitments': totalCommit
            });
          }
        }
      },
    );
    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        data = doc['Current Expences data'];

        setState(() {
          _newExpences = convertListOfMapsToList(data);
        });
        for (var index = 0; index < data.length; index++) {
          String currentmonth = formatterMonth.format(now);
          if (formatterMonth.format(data[index]['Date'].toDate()) ==
              currentmonth) {
            totalExp += data[index]['Amount'];
          }
        }
      },
    );
  }

  List<Expences> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return Expences(
        newBudgetType: listOfMaps[index]['Budget'],
        dateTime: listOfMaps[index]['Date'].toDate(),
        amount: listOfMaps[index]['Amount'],
      );
    });
  }

  List<Commitment> convertListOfMapsToListCommitment(listOfMaps) {
    return List.generate(
      listOfMaps.length,
      (index) {
        return Commitment(
          title: listOfMaps[index]['title'],
          commitType: listOfMaps[index]['type'],
          amount: listOfMaps[index]['amount'],
          commitdatetype: listOfMaps[index]['commitDateType'],
          date: listOfMaps[index]['date'].toDate(),
          paidStatus: listOfMaps[index]['bool'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              margin: const EdgeInsets.fromLTRB(10, 15, 5, 15),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('usersIncomeData')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      if (snapshot.data == null) const Text('Wlcome'),
                      if (snapshot.hasData)
                        SizedBox(
                          width: 170,
                          child: Card(
                            color: Colors.green[500],
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Total Income',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ${f.format(snapshot.data!['total Incom'])}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 90,
              margin: const EdgeInsets.fromLTRB(5, 15, 10, 15),
              child: Row(
                children: [
                  SizedBox(
                    width: 170,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: const Text('UFin'),
                              ),
                              body: const PaymentScreen(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.red[500],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                'Total Expences',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '₹ ${f.format(totalExp)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              margin: const EdgeInsets.fromLTRB(10, 15, 5, 15),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users Saving Amount')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      if (snapshot.data == null) const Text('Wlcome'),
                      if (snapshot.hasData)
                        SizedBox(
                          width: 170,
                          child: Card(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Savings Target',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ${f.format(snapshot.data!['saving Amount'])}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 90,
              margin: const EdgeInsets.fromLTRB(5, 15, 10, 15),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('usersIncomeData')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot1) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('usersIncomeData')
                        .doc(userEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          if (snapshot.data == null) const Text('Wlcome'),
                          if (snapshot.hasData)
                            SizedBox(
                              width: 170,
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Savings So far',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '₹ ${f.format(snapshot1.data!['total Incom'] - totalExp)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        for (var i = 0; i < commitmentList.length; i++)
          if (formatter.format(commitmentList[i].date) ==
                  formatter.format(now) &&
              commitmentList[i].paidStatus == false)
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                child: Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        Text(
                          'Have you paid your ${commitmentList[i].title}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            _newExpences.add(
                              Expences(
                                newBudgetType: commitmentList[i].title,
                                dateTime: DateTime.now(),
                                amount: commitmentList[i].amount,
                              ),
                            );

                            commitmentList.remove(commitmentList[i]);

                            commitmentList.add(
                              Commitment(
                                title: commitmentList1[i].title,
                                amount: commitmentList1[i].amount,
                                commitType: commitmentList1[i].commitType,
                                date: commitmentList1[i].date,
                                commitdatetype:
                                    commitmentList1[i].commitdatetype,
                                paidStatus: true,
                              ),
                            );

                            List<Map<String, Object>> data1 = [
                              for (var i in commitmentList)
                                {
                                  'amount': i.amount,
                                  'date': i.date,
                                  'bool': i.paidStatus,
                                  'commitDateType': i.commitdatetype,
                                  'title': i.title,
                                  'type': i.commitType,
                                }
                            ];

                            List<Map<String, Object>> data = [
                              for (var i in _newExpences)
                                {
                                  'Amount': i.amount,
                                  'Date': i.dateTime,
                                  'Budget': i.newBudgetType,
                                }
                            ];

                            FirebaseFirestore.instance
                                .collection('UserExpencesData')
                                .doc(userEmail)
                                .set({
                              'Current Expences data': data,
                            });

                            FirebaseFirestore.instance
                                .collection("users Monthly Commitment")
                                .doc(userEmail)
                                .set({
                              'commitemt': data1,
                              'assets commitment': assetsCommit,
                              'lablity commitment': liabilityCommit,
                              'balance budget befor saving': balanceBeforeBuget,
                              'total commitments': totalCommit
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
