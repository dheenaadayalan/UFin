import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var f = NumberFormat('##,##,###');

class PlanerHeader extends StatefulWidget {
  const PlanerHeader({super.key});

  @override
  State<PlanerHeader> createState() => _HeaderState();
}

class _HeaderState extends State<PlanerHeader> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  num totalExp = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     'Your Monthly',
        //     style: Theme.of(context).textTheme.headlineSmall,
        //   ),
        // ),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserExpencesData')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  Widget contex = const Center(
                    child: CircularProgressIndicator(),
                  );

                  if (snapshot.hasData) {
                    List data = snapshot.data!['Current Expences data'];

                    for (var i = 0; i < data.length; i++) {
                      totalExp += data[i]['Amount'];
                    }

                    contex = Row(
                      children: [
                        if (snapshot.data == null) const Text('Wlcome'),
                        if (snapshot.hasData)
                          SizedBox(
                            width: 170,
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
                                                  .onPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  }
                  return contex;
                },
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
      ],
    );
  }
}
