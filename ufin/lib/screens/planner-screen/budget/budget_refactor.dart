import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ufin/models/budget_model.dart';

class BudgetRefactor extends StatefulWidget {
  const BudgetRefactor({super.key});

  @override
  State<BudgetRefactor> createState() => _BudgetRefactorState();
}

class _BudgetRefactorState extends State<BudgetRefactor> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Budget> budgetPerorityList = [];
  List<BudgetPerority> budget = [];

  @override
  void initState() {
    initializeBudgetPerority();
    super.initState();
  }

  void initializeBudgetPerority() async {
    await FirebaseFirestore.instance
        .collection('usersBudgetPerority')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List budgetMap = doc['budget type'];
        setState(() {
          budgetPerorityList = convertListOfMapsToListBudget(budgetMap);
        });
        for (var i = 0; i < budgetPerorityList.length; i++) {
          budget.add(
            BudgetPerority(
              title: budgetPerorityList[i].title,
              perferance: budgetPerorityList[i].perferance,
              amount: budgetPerorityList[i].amount,
              index: budgetPerorityList.indexOf(budgetPerorityList[i]) + 1,
            ),
          );
        }
      },
    );
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

  @override
  Widget build(BuildContext context) {
    print(budget);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: budget.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Text(budget[index].title),
                    const SizedBox(width: 10),
                    Text(budget[index].amount.toString()),
                    const SizedBox(width: 20),
                    Text(budget[index].index.toString()),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
