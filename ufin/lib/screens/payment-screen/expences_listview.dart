import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var f = NumberFormat('##,###');

class ExpencesListView extends StatefulWidget {
  const ExpencesListView({super.key});

  @override
  State<ExpencesListView> createState() => _ExpencesListViewState();
}

class _ExpencesListViewState extends State<ExpencesListView> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      margin: const EdgeInsets.all(8),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('UserExpencesData')
            .doc(userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          Widget contex = Center(
            child: Text(
              'There is no expences',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
          if (snapshot.hasData) {
            List userExpences = snapshot.data!['Current Expences data'];
            List amount = [];
            List commitMap = snapshot.data!['Current Expences data'];
            amount = List.generate(commitMap.length, (index) {
              return commitMap[index]['Amount'];
            });
            print(amount);

            contex = Card(
              child: ListView.builder(
                itemCount: userExpences.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                    child: Row(
                      children: [
                        if (userExpences[index]['Amount'] > 1)
                          Text(
                            userExpences[index]['Budget'].toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        const SizedBox(width: 40),
                        if (userExpences[index]['Amount'] > 1)
                          Text(
                            '₹ ${f.format(amount[index]).toString()}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        const SizedBox(width: 30),
                        if (userExpences[index]['Amount'] > 1)
                          Text(
                            DateFormat.yMMMMd('en_US')
                                .format(userExpences[index]['Date'].toDate())
                                .toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return contex;
        },
      ),
    );
  }
}