import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/quick-planner/plan_function.dart';

var f = NumberFormat('##,###');

const List<Widget> month = [
  Text('This Month'),
  Text('Evey Month'),
];

const List<Widget> commitOrBudget = [
  Text('Commiment'),
  Text('  Budget '),
];

class QuickPlanner extends StatefulWidget {
  const QuickPlanner({super.key});

  @override
  State<QuickPlanner> createState() => _QuickPlannerState();
}

class _QuickPlannerState extends State<QuickPlanner> {
  bool showBudgetOrCommitment = false;
  DateTime selectedDate = DateTime.now();
  num planAmount = 0;
  String planTitle = '';
  String planMonth = 'This Month';
  String planCommit = 'Commiment';

  var now = DateTime.now();
  var formatterMonth = DateFormat('MM');
  var formatterMonthYear = DateFormat('d');
  var formatterMonthDateYear = DateFormat('Md');

  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Budget> budgetList = [];
  List<Commitment> commitmentList = [];
  num totalIncome = 0;
  num savingTraget = 0;
  List expencesList = [];
  List<BudgetTotalExp> budgetTotalExpences = [];
  List<String> targetBudgetTypes = [];
  List<BudgetTotalExp> budgetTotalExpData = [];
  num totalExp = 0;
  num blanceAmount = 0;
  List<BudgetTotalExp> balanceBudgetAmount = [];
  num totalAssetsCommit = 0;
  num totalLiablityCommit = 0;

  bool newBudget = false;
  var newBudgetMonth = 0;

  @override
  void initState() {
    initializeBudgetAmount();
    super.initState();
  }

  void initializeBudgetAmount() async {
    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        newBudget = doc['bool'];
        newBudgetMonth =
            int.parse(formatterMonth.format(doc['Month'].toDate()));
      });
    });

    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        if (newBudget == true &&
            newBudgetMonth == int.parse(formatterMonth.format(now))) {
          List budgetMap = doc['new Budget'];
          setState(() {
            budgetList = convertListOfMapsToListBudget(budgetMap);
          });
        } else {
          List budgetMap = doc['budget type'];
          setState(() {
            budgetList = convertListOfMapsToListBudget(budgetMap);
          });
        }
      },
    );

    await FirebaseFirestore.instance
        .collection('users Monthly Commitment')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List commitmentMap = doc['commitemt'];

        setState(() {
          commitmentList = convertListOfMapsToListCommitment(commitmentMap);
          totalAssetsCommit = doc['assets commitment'];
          totalLiablityCommit = doc['lablity commitment'];
        });
      },
    );

    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        setState(() {
          totalIncome = doc['total Incom'];
        });
      },
    );

    await FirebaseFirestore.instance
        .collection('users Saving Amount')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) {
        savingTraget = doc['saving Amount'];
      },
    );

    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        newBudget = doc['bool'];
        newBudgetMonth =
            int.parse(formatterMonth.format(doc['Month'].toDate()));
      });
    });
    await FirebaseFirestore.instance
        .collection('usersIncomeData')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        setState(() {
          totalIncome = doc['total Incom'];
        });
      },
    );
    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        if (newBudget == true &&
            newBudgetMonth == int.parse(formatterMonth.format(now))) {
          List budgetMap = doc['new Budget'];
          setState(() {
            budgetList = convertListOfMapsToListBudget(budgetMap);
          });
        } else {
          List budgetMap = doc['budget type'];
          setState(() {
            budgetList = convertListOfMapsToListBudget(budgetMap);
          });
        }
      },
    );
    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List commitMap = doc['Current Expences data'];

        targetBudgetTypes = convertListOfMapsToListbudget(commitMap);

        // for (var i = 0; i < commitMap.length; i++) {
        //   totalExp += commitMap[i]['Amount'];
        // }

        for (var index = 0; index < commitMap.length; index++) {
          String currentmonth = formatterMonth.format(now);
          if (formatterMonth.format(commitMap[index]['Date'].toDate()) ==
              currentmonth) {
            totalExp += commitMap[index]['Amount'];
            budgetTotalExpences.add(
              BudgetTotalExp(
                newBudgetType: commitMap[index]['Budget'],
                amount: commitMap[index]['Amount'],
              ),
            );
          }
        }

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

        setState(() {
          blanceAmount = totalIncome - totalExp;
        });

        for (var i = 0; i < budgetList.length; i++) {
          balanceBudgetAmount.add(BudgetTotalExp(
            newBudgetType: budgetList[i].title,
            amount: budgetList[i].amount - budgetTotalExpData[i].amount,
          ));
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2024, 2));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PlanSearch(
              budgetList: budgetList,
              commitmentList: commitmentList,
              totalIncome: totalIncome,
              savingTraget: savingTraget,
              budgetTotalExpences: budgetTotalExpences,
              budgetTotalExpData: budgetTotalExpData,
              totalExp: totalExp,
              blanceAmount: blanceAmount,
              balanceBudgetAmount: balanceBudgetAmount,
              userMailId: userEmail!,
            ),
            const SizedBox(height: 20),
            //const PlanListView(),
          ],
        ),
      ),
    );
  }
}
