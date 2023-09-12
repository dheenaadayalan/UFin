import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/planner-screen/budget/budget_edit.dart';

//import 'package:ufin/models/exp_dummy_data.dart';

var f = NumberFormat('##,##,###');

class BudgetBuilder extends StatefulWidget {
  const BudgetBuilder({
    super.key,
    required this.userMailId,
    required this.userTotalBudget,
    required this.userBudgetExp,
  });

  final String userMailId;
  final num userTotalBudget;
  final List<BudgetTotalExp> userBudgetExp;

  @override
  State<BudgetBuilder> createState() => _BudgetBuilderState();
}

class _BudgetBuilderState extends State<BudgetBuilder> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  num totalExp = 0;
  //num _userTotalBudget = 0;

  @override
  void initState() {
    initialize(); //   have it for now and remove it later if not needed
    super.initState();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(widget.userMailId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        // userTotalBudget = doc['userTotalBudget'];
        // print(userTotalBudget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    num totalBudgetUsed = 0;
    for (var i = 0; i < widget.userBudgetExp.length; i++) {
      totalBudgetUsed += widget.userBudgetExp[i].amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Let's Budget Your Income",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Total Budget',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '₹ ${f.format(widget.userTotalBudget)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.red[300],
                    // color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Budget Used',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹ ${f.format(totalBudgetUsed)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.green[400],
                    //color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Balance',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹ ${f.format(widget.userTotalBudget - totalBudgetUsed)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(8),
              //height: 200,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('usersBudget')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  Widget contex = const Center(
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    List userBudget = snapshot.data!['budget type'];
                    //List actualBudget = ExpDummyData.expencesData[1]['title']; also  commitout package
                    contex = Card(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      child: ExpansionTile(
                        title: Text(
                          'List of your Budget',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                        ),
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Title:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Amount:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Due date:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: userBudget.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            userBudget[index]['title']
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹ ${f.format(userBudget[index]['amount']).toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const Spacer(),
                                          Text(
                                            userBudget[index]['perferance type']
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetEdit(
                                        userMailId: widget.userMailId,
                                        userexstingExpences:
                                            widget.userBudgetExp,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                label: const Text('Edit'),
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return contex;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Row(
                children: [
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    'Budget Used Amount',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 40),
                  Text(
                    'Balance Budget',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              height: 250,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('usersBudget')
                    .doc(userEmail)
                    .snapshots(),
                builder: (context, snapshot) {
                  Widget contex = const Center(
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    List userBudget = snapshot.data!['budget type'];
                    contex = ListView.builder(
                      itemCount: userBudget.length,
                      itemBuilder: (context, index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                userBudget[index]['title'],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              Text(
                                '₹ ${f.format(widget.userBudgetExp[index].amount).toString()}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(width: 40),
                              Text(
                                '₹ ${f.format(userBudget[index]['amount'] - widget.userBudgetExp[index].amount).toString()}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return contex;
                },
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   height: 90,
            //   margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       StreamBuilder(
            //         stream: FirebaseFirestore.instance
            //             .collection('users Saving Amount')
            //             .doc(userEmail)
            //             .snapshots(),
            //         builder: (context, snapshot) {
            //           return Card(
            //             color: Theme.of(context).colorScheme.onPrimaryContainer,
            //             child: Row(
            //               children: [
            //                 if (snapshot.data == null) const Text('Wlcome'),
            //                 if (snapshot.hasData)
            //                   SizedBox(
            //                     width: 170,
            //                     child: Padding(
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         children: [
            //                           Text(
            //                             'Savings Target',
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .titleMedium!
            //                                 .copyWith(
            //                                     color: Theme.of(context)
            //                                         .colorScheme
            //                                         .onPrimary),
            //                           ),
            //                           const SizedBox(height: 10),
            //                           Text(
            //                             '₹ ${f.format(snapshot.data!['saving Amount'])}',
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .headlineSmall!
            //                                 .copyWith(
            //                                     color: Theme.of(context)
            //                                         .colorScheme
            //                                         .onPrimary),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //       const SizedBox(width: 20),
            //       StreamBuilder(
            //         stream: FirebaseFirestore.instance
            //             .collection('UserExpencesData')
            //             .doc(userEmail)
            //             .snapshots(),
            //         builder: (context, snapshot) {
            //           Widget contex = const Center(
            //             child: CircularProgressIndicator(),
            //           );

            //           if (snapshot.hasData) {
            //             List data = snapshot.data!['Current Expences data'];

            //             for (var i = 0; i < data.length; i++) {
            //               totalExp += data[i]['Amount'];
            //             }

            //             contex = StreamBuilder(
            //                 stream: FirebaseFirestore.instance
            //                     .collection('usersIncomeData')
            //                     .doc(userEmail)
            //                     .snapshots(),
            //                 builder: (context, snapshot) {
            //                   return Row(
            //                     children: [
            //                       if (snapshot.data == null)
            //                         const Text('Wlcome'),
            //                       if (snapshot.hasData)
            //                         SizedBox(
            //                           width: 170,
            //                           child: Card(
            //                             color: Theme.of(context)
            //                                 .colorScheme
            //                                 .onPrimaryContainer,
            //                             child: Padding(
            //                               padding: const EdgeInsets.all(10.0),
            //                               child: Column(
            //                                 children: [
            //                                   Text(
            //                                     'Savings So far',
            //                                     style: Theme.of(context)
            //                                         .textTheme
            //                                         .titleMedium!
            //                                         .copyWith(
            //                                             color: Theme.of(context)
            //                                                 .colorScheme
            //                                                 .onPrimary),
            //                                   ),
            //                                   const SizedBox(height: 10),
            //                                   Text(
            //                                     '₹ ${f.format(snapshot.data!['total Incom'] - totalExp)}',
            //                                     style: Theme.of(context)
            //                                         .textTheme
            //                                         .headlineSmall!
            //                                         .copyWith(
            //                                           color: Theme.of(context)
            //                                               .colorScheme
            //                                               .onPrimary,
            //                                         ),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                     ],
            //                   );
            //                 });
            //           }
            //           return contex;
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
