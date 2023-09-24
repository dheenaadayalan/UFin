import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/models/test_insigits.dart';

var f = NumberFormat('##,###');

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
  num totalExp = 0;
  num blanceAmount = 0;
  num last6DaysExp = 0;
  List<BudgetTotalExp> balanceBudgetAmount = [];
  List<TextInsigits> textInsigitsData = [];
  num totalAssetsCommit = 0;
  num totalLiablityCommit = 0;
  var now = DateTime.now();
  var formatterMonth = DateFormat('MM');
  var formatterMonthYear = DateFormat('d');
  var formatterMonthDateYear = DateFormat('Md');

  @override
  void initState() {
    initializeBudgetTotalIncome();
    initializeBudgetAmount();
    initializeCommitment();
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
      (DocumentSnapshot doc) async {
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
      (DocumentSnapshot doc) async {
        List commitmentMap = doc['commitemt'];

        setState(() {
          commitmentList = convertListOfMapsToListCommitment(commitmentMap);
          totalAssetsCommit = doc['assets commitment'];
          totalLiablityCommit = doc['lablity commitment'];
        });
        for (var i = 0; i < commitmentList.length; i++) {
          int balancedate =
              int.parse(formatterMonthYear.format(commitmentList[i].date)) -
                  int.parse(formatterMonthYear.format(now));
          if (balancedate <= 5 && balancedate >= 0) {
            textInsigitsData.add(
              TextInsigits(
                data:
                    'You still have $balancedate days left for your ${commitmentList[i].title} payment',
                colorType: Colors.orange,
              ),
            );
          }
        }
        if (totalLiablityCommit > totalAssetsCommit) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  'Your making more liability payment of ₹${f.format(totalLiablityCommit)}, than assets payment, try increasing your asset payment to increaing your assets ',
              colorType: Colors.blue,
            ),
          );
        }
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
      (DocumentSnapshot doc) async {
        setState(() {
          totalIncome = doc['total Incom'];
        });
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
        List budgetMap = doc['budget type'];
        setState(() {
          budgetList = convertListOfMapsToListBudget(budgetMap);
        });
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

        for (var index = 0; index < commitMap.length; index++) {
          int currentDay = int.parse(formatterMonthYear.format(now));
          String currentmonth = formatterMonth.format(now);
          if (formatterMonth.format(commitMap[index]['Date'].toDate()) ==
              currentmonth) {
            if (int.parse(formatterMonthYear
                        .format(commitMap[index]['Date'].toDate())) >=
                    (currentDay - 5) &&
                int.parse(formatterMonthYear
                        .format(commitMap[index]['Date'].toDate())) <=
                    currentDay) {
              last6DaysExp += commitMap[index]['Amount'];
            }
          }
        }
        if (last6DaysExp > (totalIncome * 23 / 100)) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  "You have spent more than 20% of your Income in just 5 day's, At this rate you can't achieve savings Targrt ",
              colorType: Colors.red,
            ),
          );
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

        for (var i = 0; i < budgetTotalExpData.length; i++) {
          if (budgetTotalExpData[i].amount >=
                  (budgetList[i].amount * 80 / 100) &&
              budgetTotalExpData[i].amount <= (budgetList[i].amount)) {
            textInsigitsData.add(
              TextInsigits(
                data:
                    'You have spent ${((budgetTotalExpData[i].amount / budgetList[i].amount) * 100).toStringAsPrecision(3)} of your budget on ${budgetList[i].title}',
                colorType: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
        }

        for (var i = 0; i < budgetTotalExpData.length; i++) {
          if (budgetTotalExpData[i].amount >= (budgetList[i].amount)) {
            textInsigitsData.add(
              TextInsigits(
                data:
                    'You have spent ${((budgetTotalExpData[i].amount / budgetList[i].amount) * 100).toStringAsPrecision(3)} % of your budget on ${budgetList[i].title}',
                colorType: Colors.red,
              ),
            );
          }
        }

        if (blanceAmount > (totalExp * 50 / 100)) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  'You have spent less than 50% your Income, Your saving is ₹ ${f.format(blanceAmount)}',
              colorType: Colors.green,
            ),
          );
        } else if (totalIncome == totalExp) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  'You have spent all of your Income, Your saving is 0 this month',
              colorType: Colors.red,
            ),
          );
        }

        if (totalExp >= (totalIncome * 80 / 100)) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  'You have spent $totalExp, that is more than ${(totalExp / totalIncome) * 100} of your Total Income $totalIncome',
              colorType: Colors.red,
            ),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              'Insights',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textInsigitsData.length.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
        children: [
          SingleChildScrollView(
            child: Container(
              height: 200,
              margin: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: textInsigitsData.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${index + 1}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Card(
                          color: textInsigitsData[index].colorType,
                          //color: Theme.of(context).colorScheme.background,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textInsigitsData[index].data,
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  letterSpacing: .5,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
