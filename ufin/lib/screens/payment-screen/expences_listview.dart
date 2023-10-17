import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufin/models/expences_modes.dart';

var f = NumberFormat('##,###');
var formatter = DateFormat('MM');
var now = DateTime.now();

class ExpencesListView extends StatefulWidget {
  const ExpencesListView({super.key});

  @override
  State<ExpencesListView> createState() => _ExpencesListViewState();
}

class _ExpencesListViewState extends State<ExpencesListView> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    List<Expences> expancesListData = [];
    List<Expences> convertListOfMapsToListExpences(listOfMaps) {
      return List.generate(listOfMaps.length, (index) {
        return Expences(
          amount: listOfMaps[index]['Amount'],
          dateTime: listOfMaps[index]['Date'].toDate(),
          newBudgetType: listOfMaps[index]['Budget'],
        );
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height / 2, //400,
      margin: const EdgeInsets.all(8),
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
            List userExpences = snapshot.data!['Current Expences data'];
            expancesListData = convertListOfMapsToListExpences(userExpences);
            List amount = [];
            List commitMap = snapshot.data!['Current Expences data'];
            amount = List.generate(commitMap.length, (index) {
              return commitMap[index]['Amount'];
            });

            contex = ListView.builder(
              itemCount: userExpences.length,
              itemBuilder: (context, index) {
                print(expancesListData.length);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                  child: Row(
                    children: [
                      if (userExpences[index]['Amount'] > 1 &&
                          formatter.format(
                                  userExpences[index]['Date'].toDate()) ==
                              formatter.format(now))
                        Text(
                          userExpences[index]['Budget'].toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      const Spacer(),
                      if (userExpences[index]['Amount'] > 1 &&
                          formatter.format(
                                  userExpences[index]['Date'].toDate()) ==
                              formatter.format(now))
                        Text(
                          '₹ ${f.format(amount[index]).toString()}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      const Spacer(),
                      if (userExpences[index]['Amount'] > 1 &&
                          formatter.format(
                                  userExpences[index]['Date'].toDate()) ==
                              formatter.format(now))
                        Text(
                          DateFormat.yMMMMd('en_US')
                              .format(userExpences[index]['Date'].toDate())
                              .toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      const Spacer(),
                      if (userExpences[index]['Amount'] > 1 &&
                          formatter.format(
                                  userExpences[index]['Date'].toDate()) ==
                              formatter.format(now))
                        IconButton(
                          onPressed: () async {
                            if (expancesListData.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Try again Or check your Internet Speed.'),
                                ),
                              );
                              return;
                            }
                            expancesListData.remove(expancesListData[index]);

                            if (expancesListData.length > 1 &&
                                expancesListData.length ==
                                    (userExpences.length - 1)) {
                              List<Map<String, Object>> data = [
                                for (var i in expancesListData)
                                  {
                                    'Amount': i.amount,
                                    'Date': i.dateTime,
                                    'Budget': i.newBudgetType,
                                  }
                              ];

                              await FirebaseFirestore.instance
                                  .collection('UserExpencesData')
                                  .doc(userEmail)
                                  .set({
                                'Current Expences data': data,
                              });
                              setState(() {});
                            } else {
                              return;
                            }
                          },
                          icon: const Icon(Icons.delete),
                        )
                    ],
                  ),
                );
              },
            );
          }
          return contex;
        },
      ),
    );
  }
}
