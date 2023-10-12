import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/home_tabs.dart';

var f = NumberFormat('##,##,###');

class RefactorCommit extends StatefulWidget {
  const RefactorCommit(
      {super.key,
      required this.refactorAmount,
      required this.selectedBudget,
      required this.selectedBudgetToRefactored,
      required this.userBudgetExp});

  final BudgetRefactor1 selectedBudget;
  final int refactorAmount;
  final BudgetRefactor1 selectedBudgetToRefactored;
  final List<BudgetTotalExp> userBudgetExp;

  @override
  State<RefactorCommit> createState() => _RefactorCommitState();
}

class _RefactorCommitState extends State<RefactorCommit> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Budget> userBudget = [];
  List<Budget> userCommitBudget = [];

  @override
  void initState() {
    initializeBudgetPerority();
    super.initState();
  }

  void initializeBudgetPerority() async {
    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List budgetMap = doc['budget type'];
        setState(() {
          userBudget = convertListOfMapsToListBudget(budgetMap);
        });
      },
    );
    for (var i = 0; i < userBudget.length; i++) {
      if (userBudget[i].title == widget.selectedBudget.title) {
        userCommitBudget.add(
          Budget(
            title: userBudget[i].title,
            perferance: userBudget[i].perferance,
            amount: userBudget[i].amount + widget.refactorAmount,
          ),
        );
      } else if (userBudget[i].title ==
          widget.selectedBudgetToRefactored.title) {
        userCommitBudget.add(
          Budget(
            title: userBudget[i].title,
            perferance: userBudget[i].perferance,
            amount: userBudget[i].amount - widget.refactorAmount,
          ),
        );
      } else {
        userCommitBudget.add(
          Budget(
            title: userBudget[i].title,
            perferance: userBudget[i].perferance,
            amount: userBudget[i].amount,
          ),
        );
      }
    }
  }

  List<Budget> convertListOfMapsToListBudget(listOfMaps) {
    return List.generate(
      listOfMaps.length,
      (index) {
        return Budget(
          title: listOfMaps[index]['title'],
          perferance: listOfMaps[index]['perferance type'],
          amount: listOfMaps[index]['amount'],
        );
      },
    );
  }

  void commitChanges() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
      (Route route) => false,
    );

    List<Map<String, Object>> data = [
      for (var index in userCommitBudget)
        {
          'title': index.title,
          'amount': index.amount,
          'perferance type': index.perferance,
        }
    ];

    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .update(
      {
        'new Budget': data,
      },
    );

    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .set(
      {
        'bool': true,
        'Month': DateTime.now(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '₹ ${f.format(widget.refactorAmount)} form the your ${widget.selectedBudgetToRefactored.title} will added to ${widget.selectedBudget.title} untill end this month.',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'By following this new budget you can still achieve your savings goal',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Your New Budget',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Text(
                  'Budget name',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 30),
                Text(
                  'New Amount',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Card(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: userCommitBudget.length,
                    itemBuilder: (context, index) => Card(
                      color: Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              userCommitBudget[index].title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                            Text(
                              userCommitBudget[index].perferance,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 30),
                            Text(
                              userCommitBudget[index].amount.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: commitChanges,
            child: const Text('Commit New Budget'),
          )
        ],
      ),
    );
  }
}
