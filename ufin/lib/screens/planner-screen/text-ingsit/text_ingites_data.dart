import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';

class TextIngsitiesData extends StatefulWidget {
  const TextIngsitiesData({super.key});

  @override
  State<TextIngsitiesData> createState() => _TextIngsitiesDataState();
}

class _TextIngsitiesDataState extends State<TextIngsitiesData> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Budget> budgetList = [];
  List<Commitment> commitmentList = [];
  num totalIncome = 0;
  num savingTraget = 0;
  List expencesList = [];
  List<BudgetTotalExp> budgetTotalExpences = [];
  List<String> targetBudgetTypes = [];
  List<BudgetTotalExp> budgetTotalExpData = [];

  @override
  void initState() {
    initializeBudgetAmount();
    initializeCommitment();
    initializeBudgetTotalIncome();
    initializeSavingTraget();
    initializeExpences();
    super.initState();
  }

  void initializeBudgetAmount() async {
    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) {
        List budgetMap = doc['budget type'];
        setState(() {
          budgetList = convertListOfMapsToListBudget(budgetMap);
        });
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

  void initializeCommitment() async {
    await FirebaseFirestore.instance
        .collection('users Monthly Commitment')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) {
        List commitmentMap = doc['commitemt'];
        setState(() {
          commitmentList = convertListOfMapsToListCommitment(commitmentMap);
        });
      },
    );
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
          date: listOfMaps[index]['date'],
        );
      },
    );
  }

  void initializeBudgetTotalIncome() async {
    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) {
        totalIncome = doc['total Incom'];
      },
    );
  }

  void initializeSavingTraget() async {
    await FirebaseFirestore.instance
        .collection('users Saving Amount')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) {
        savingTraget = doc['saving Amount'];
      },
    );
  }

  void initializeExpences() async {
    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      List commitMap = doc['Current Expences data'];
      targetBudgetTypes = convertListOfMapsToListbudget(commitMap);
      budgetTotalExpences = convertListOfMapsToListExpences(commitMap);
    });
  }

  List<BudgetTotalExp> convertListOfMapsToListExpences(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return BudgetTotalExp(
        newBudgetType: listOfMaps[index]['Budget'],
        amount: listOfMaps[index]['Amount'],
      );
    });
  }

  List<String> convertListOfMapsToListbudget(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return listOfMaps[index]['Budget'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> totalAmounts = {};

    for (String budgetType in targetBudgetTypes) {
      double totalAmount = budgetTotalExpences
          .where((item) => item.newBudgetType == budgetType)
          .map((item) => item.amount)
          .fold(0.0, (previousValue, amount) => previousValue + amount);

      totalAmounts[budgetType] = totalAmount;
    }

    budgetTotalExpData = totalAmounts.entries
        .map((entry) =>
            BudgetTotalExp(newBudgetType: entry.key, amount: entry.value))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: budgetList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        budgetList[index].title,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        budgetList[index].amount.toString(),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
              child: ListView.builder(
                itemCount: commitmentList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        commitmentList[index].title,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        commitmentList[index].amount.toString(),
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(totalIncome.toString()),
            Text(savingTraget.round().toString()),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: budgetTotalExpData.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text(
                        budgetTotalExpData[index].newBudgetType,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        budgetTotalExpData[index].amount.round().toString(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
