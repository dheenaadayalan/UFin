import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/models/test_insigits.dart';

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
  List<BudgetTotalExp> balanceBudgetAmount = [];
  List<TextInsigits> textInsigitsData = [];
  var now = DateTime.now();
  var formatterMonth = DateFormat('MM');
  var formatterMonthYear = DateFormat('d');

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
        });
        for (var i = 0; i < commitmentList.length; i++) {
          int balancedate =
              int.parse(formatterMonthYear.format(commitmentList[i].date)) -
                  int.parse(formatterMonthYear.format(now));
          if (balancedate <= 5 && balancedate >= 0) {
            textInsigitsData.add(
              TextInsigits(
                data:
                    'You still have $balancedate days lest for your ${commitmentList[i].title} payment',
                colorType: Colors.orange,
              ),
            );
          }
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

        for (var i = 0; i < budgetTotalExpData.length; i++) {
          if (budgetTotalExpData[i].amount >=
                  (budgetList[i].amount * 80 / 100) &&
              budgetTotalExpData[i].amount <= (budgetList[i].amount)) {
            textInsigitsData.add(
              TextInsigits(
                data:
                    'You have spent ${(budgetTotalExpData[i].amount / budgetList[i].amount) * 100} of your budget on ${budgetList[i].title}',
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
                    'You have spent 100% of your budget on ${budgetList[i].title}',
                colorType: Colors.red,
              ),
            );
          }
        }

        if (blanceAmount > (totalExp * 50 / 100)) {
          textInsigitsData.add(
            TextInsigits(
              data:
                  'You have spent less than 50% your Income, Your saving is $blanceAmount',
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
    return ExpansionTile(
      title: Text(
        'Insights',
        style: Theme.of(context).textTheme.titleLarge,
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
                  crossAxisAlignment: CrossAxisAlignment.start, // dummy data
                  children: [
                    Text(
                      "\u2022",
                      style: Theme.of(context).textTheme.titleLarge,
                    ), //bullet text
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
                      ), //text
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
