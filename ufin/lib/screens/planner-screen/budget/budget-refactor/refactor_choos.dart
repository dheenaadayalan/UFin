import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/home_tabs.dart';
import 'package:ufin/screens/planner-screen/budget/budget-refactor/refactor_commit.dart';

var f = NumberFormat('##,##,###');

class RefactorChoose extends StatefulWidget {
  const RefactorChoose({
    super.key,
    required this.selectedBudget,
    required this.refactorAmount,
    required this.userBudgetExp,
  });

  final BudgetRefactor1 selectedBudget;
  final int refactorAmount;
  final List<BudgetTotalExp> userBudgetExp;

  @override
  State<RefactorChoose> createState() => _RefactorChooseState();
}

class _RefactorChooseState extends State<RefactorChoose> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  List<Budget> budgetPerorityList = [];
  List<BudgetPerority> budget = [];
  List<BudgetPerority> fliteredBudget = [];
  int selectedIndex = 0;
  BudgetRefactor1? selectedBudgetToRefactored;
  bool newBudget1 = false;
  var newBudgetMonth = 0;
  var formatter = DateFormat('MM');
  var now = DateTime.now();

  @override
  void initState() {
    initializeBudgetPerority();
    super.initState();
  }

  void initializeBudgetPerority() async {
    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        newBudget1 = doc['bool'];
        newBudgetMonth = int.parse(formatter.format(doc['Month'].toDate()));
      });
    });

    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then(
      (DocumentSnapshot doc) async {
        List budgetMap = doc['budget type'];
        setState(() {
          budgetPerorityList = convertListOfMapsToListBudget(budgetMap);
        });
        if (newBudget1 == true &&
            newBudgetMonth == int.parse(formatter.format(now))) {
          List budgetMap = doc['new Budget'];
          setState(() {
            budgetPerorityList = convertListOfMapsToListBudget(budgetMap);
          });
        } else {
          List budgetMap = doc['budget type'];
          setState(() {
            budgetPerorityList = convertListOfMapsToListBudget(budgetMap);
          });
        }
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
        for (var i = 0; i < budget.length; i++) {
          if ((budget[i].amount - widget.userBudgetExp[i].amount) >=
                  (widget.refactorAmount) &&
              (widget.selectedBudget.title != budget[i].title)) {
            fliteredBudget.add(
              BudgetPerority(
                title: budgetPerorityList[i].title,
                perferance: budgetPerorityList[i].perferance,
                amount: budgetPerorityList[i].amount,
                index: budgetPerorityList.indexOf(budgetPerorityList[i]) + 1,
              ),
            );
          }
        }
      },
    );
    if (fliteredBudget.isNotEmpty) {
      selectedBudgetToRefactored = BudgetRefactor1(
        title: fliteredBudget[0].title,
        perferance: fliteredBudget[0].perferance.toString(),
        budgetAmount: fliteredBudget[0].amount,
        balance: fliteredBudget[0].amount -
            (widget
                .userBudgetExp[
                    int.parse(fliteredBudget[0].index.toString()) - 1]
                .amount),
        totalExp: widget
            .userBudgetExp[int.parse(fliteredBudget[0].index.toString()) - 1]
            .amount,
      );
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

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            width: 400,
            child: Image.asset('assets/giphy.gif'),
          ),
          // const SizedBox(height: 30),
          Text(
            'There no need to Refactor your budget for now- Your all good❤️',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer)),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return const HomeTabsScreen();
                  },
                ),
                (Route route) => false,
              );
            },
            child: const Text('Back Home 🏡'),
          ),
        ],
      ),
    );
    if (fliteredBudget.isNotEmpty) {
      activeScreen = Scaffold(
        appBar: AppBar(
          title: const Text('UFin'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 70,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background),
                    height: 100,
                    child: Column(
                      children: [
                        Text(
                          'We have found ${fliteredBudget.length} of your Budget that can be Refactored',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Selecte One budget that you wish to Refactor',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: fliteredBudget.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: selectedIndex == index
                              ? RoundedRectangleBorder(
                                  side: const BorderSide(width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                )
                              : null,
                          tileColor: selectedIndex == index
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : null,
                          onTap: () {
                            setState(
                              () {
                                selectedIndex = index;
                                selectedBudgetToRefactored = BudgetRefactor1(
                                    title: fliteredBudget[index].title,
                                    perferance: fliteredBudget[index]
                                        .perferance
                                        .toString(),
                                    budgetAmount: fliteredBudget[index].amount,
                                    balance: fliteredBudget[index].amount -
                                        (widget
                                            .userBudgetExp[int.parse(
                                                    fliteredBudget[index]
                                                        .index
                                                        .toString()) -
                                                1]
                                            .amount),
                                    totalExp: widget
                                        .userBudgetExp[int.parse(
                                                fliteredBudget[index]
                                                    .index
                                                    .toString()) -
                                            1]
                                        .amount);
                              },
                            );
                          },
                          title: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fliteredBudget[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Importances:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(width: 75),
                                          Text(
                                            fliteredBudget[index]
                                                .perferance
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            'Budget Amount:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(width: 55),
                                          Text(
                                            '₹ ${f.format(fliteredBudget[index].amount).toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            'Amount Used:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(width: 71),
                                          Text(
                                            '₹ ${f.format(widget.userBudgetExp[int.parse(fliteredBudget[index].index.toString()) - 1].amount).toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            'Balance:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(width: 110),
                                          Text(
                                            '₹ ${f.format(fliteredBudget[index].amount - (widget.userBudgetExp[int.parse(fliteredBudget[index].index.toString()) - 1].amount)).toString()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 90,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RefactorCommit(
                                  refactorAmount: widget.refactorAmount,
                                  selectedBudget: widget.selectedBudget,
                                  selectedBudgetToRefactored:
                                      selectedBudgetToRefactored!,
                                  userBudgetExp: widget.userBudgetExp,
                                ),
                              ),
                            );
                          },
                          child: const Text('Commit'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return activeScreen;
  }
}
