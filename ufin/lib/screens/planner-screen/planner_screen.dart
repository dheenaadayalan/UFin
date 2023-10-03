import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufin/models/expences_modes.dart';

import 'package:ufin/screens/planner-screen/budget/barchart/budget_bar_chart.dart';
import 'package:ufin/screens/planner-screen/budget/budget-refactor/budget_refactor.dart';
import 'package:ufin/screens/planner-screen/commit_builder.dart';
import 'package:ufin/screens/planner-screen/planner_header.dart';
import 'package:ufin/screens/planner-screen/text-ingsit/text_ingites_data.dart';

//import 'package:ufin/screens/planner-screen/text-ingsit/text_ingtits.dart';

var f = NumberFormat('##,##,###');
var formatter = DateFormat('MM');

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key, required this.selectedPageIndex});

  final int selectedPageIndex;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  String? userMail = FirebaseAuth.instance.currentUser!.email;

  List<BudgetTotalExp> budgetTotalExpData = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc('test2@gmail.com')
        .get()
        .then((DocumentSnapshot doc) async {
      List commitMap = doc['Current Expences data'];

      Map<String, double> totalAmounts = {};

      List<String> targetBudgetTypes = convertListOfMapsToListbudget(commitMap);

      List<BudgetTotalExp> budgetTotalExpences =
          convertListOfMapsToListTotalExpences(commitMap);

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
    });
  }

  List<String> convertListOfMapsToListbudget(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return listOfMaps[index]['Budget'];
    });
  }

  List<BudgetTotalExp> convertListOfMapsToListTotalExpences(listOfMaps) {
    List<BudgetTotalExp> budgetTotalExpences1 = [];
    for (var index = 0; index < listOfMaps.length; index++) {
      String currentmonth = formatter.format(now);
      if (formatter.format(listOfMaps[index]['Date'].toDate()) ==
          currentmonth) {
        budgetTotalExpences1.add(
          BudgetTotalExp(
            newBudgetType: listOfMaps[index]['Budget'],
            amount: listOfMaps[index]['Amount'],
          ),
        );
      }
    }

    return budgetTotalExpences1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        PlanerHeader(selectedPageIndex: widget.selectedPageIndex),
        const TextIngsitiesData(),
        const BudgetBarChart(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Over Spend any of your Budgets?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.tertiaryContainer),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BudgetRefactor(userBudgetExp: budgetTotalExpData),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Budget Refactor',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                    // const Icon(Icons.arrow_right_alt)
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const CommitBuilder(),
      ]),
    );
  }
}
