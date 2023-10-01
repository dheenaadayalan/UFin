import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/home_tabs.dart';
import 'package:ufin/screens/planner-screen/budget/budget-refactor/refactor_choos.dart';

var f = NumberFormat('##,##,###');

class BudgetRefactor extends StatefulWidget {
  const BudgetRefactor({
    super.key,
    required this.userBudgetExp,
  });

  final List<BudgetTotalExp> userBudgetExp;

  @override
  State<BudgetRefactor> createState() => _BudgetRefactorState();
}

class _BudgetRefactorState extends State<BudgetRefactor> {
  final _form = GlobalKey<FormState>();
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<Budget> budgetPerorityList = [];
  List<BudgetPerority> budget = [];
  List<BudgetPerority> fliteredBudget = [];
  bool newBudget = true;
  int selectedIndex = 0;
  BudgetRefactor1? selectedBudget;
  int refactorAmount = 0;
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
              index: i,
            ),
          );
        }
        for (var i = 0; i < budget.length; i++) {
          if (widget.userBudgetExp[i].amount >=
                  (budget[i].amount * (95 / 100)) &&
              (budget[i].perferance == 'Highest Priority' ||
                  budget[i].perferance == 'Priority' ||
                  budget[i].perferance == 'In between')) {
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
      selectedBudget = BudgetRefactor1(
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

  void onSave() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
      (Route route) => false,
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

  void onDelete() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
      (Route route) => false,
    );
    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .set(
      {
        'bool': false,
        'Month': DateTime.now(),
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
                    height: 200,
                    child: Column(
                      children: [
                        Text(
                          'We have found ${fliteredBudget.length} of your Budget that can be Refactored',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'How much amount you needed to refactor',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _form,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'How Much',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Pls enter the value';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              refactorAmount = int.parse(newValue!);
                            },
                          ),
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
                    height: 450,
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
                                selectedBudget = BudgetRefactor1(
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
                            final isValid = _form.currentState!.validate();

                            if (!isValid) {
                              return;
                            }
                            _form.currentState!.save();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RefactorChoose(
                                  selectedBudget: selectedBudget!,
                                  refactorAmount: refactorAmount,
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


  // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         onSave();
            //       },
            //       child: const Text('Commit'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         onDelete();
            //       },
            //       child: const Text('Delet it'),
            //     ),
            //   ],
            // ),