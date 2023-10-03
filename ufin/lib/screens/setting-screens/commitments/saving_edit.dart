import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/planner-screen/budget/budget_edit.dart';
import 'package:ufin/screens/setup-screens/budget/budget_info.dart';

var f = NumberFormat('##,##,###');

class SavingCalEdit extends StatefulWidget {
  const SavingCalEdit({
    super.key,
    required this.totalIncome,
    required this.userMailId,
    required this.balanceToBudget,
  });

  final String userMailId;
  final num totalIncome;
  final num balanceToBudget;

  @override
  State<SavingCalEdit> createState() => _SavingCalStateEdit();
}

class _SavingCalStateEdit extends State<SavingCalEdit> {
  double _currentSliderValue = 20;
  var now = DateTime.now();
  List<BudgetTotalExp> budgetTotalExpences = [];
  bool newBudget = false;
  var newBudgetMonth = 0;
  var formatter = DateFormat('MM');
  List budgetMaxExpences = [];
  List<BudgetTotalExp> budgetTotalExpData = [];
  List<BudgetTotalExp> budgetTotalExpData1 = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void summit() async {
    final savingAmount = (widget.totalIncome * _currentSliderValue) / 100;
    final balanceToBudget = widget.balanceToBudget -
        ((widget.totalIncome * _currentSliderValue) / 100);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BudgetScreen(
            userMailId: widget.userMailId, balanceBuget: balanceToBudget),
      ),
    );

    await FirebaseFirestore.instance
        .collection('users Saving Amount')
        .doc(widget.userMailId)
        .set(
      {
        'saving Amount': savingAmount,
        'balance to budget': balanceToBudget,
      },
    );
  }

  void initialize() async {
    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(widget.userMailId)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        newBudget = doc['bool'];

        newBudgetMonth = int.parse(formatter.format(doc['Month'].toDate()));
      });
    });
  }

  List convertListOfMapsToList2(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return listOfMaps[index]['amount'];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usersBudget')
              .doc(widget.userMailId)
              .snapshots(),
          builder: (context, snapshot) {
            Widget contex = const Center(
              child: CircularProgressIndicator(),
            );
            if (newBudget == true &&
                newBudgetMonth == int.parse(formatter.format(now)) &&
                snapshot.hasData) {
              List _userBudget = snapshot.data!['new Budget'];

              budgetMaxExpences = convertListOfMapsToList2(_userBudget);

              //final num userTotalBudget = snapshot.data!['userTotalBudget'];

              contex = StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserExpencesData')
                    .doc(widget.userMailId)
                    .snapshots(),
                builder: (context, snapshot) {
                  Widget contex = const Center(
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    Map<String, double> totalAmounts = {};
                    List data = snapshot.data!['Current Expences data'];

                    List<String> targetBudgetTypes =
                        convertListOfMapsToListbudget(data);

                    budgetTotalExpences =
                        convertListOfMapsToListTotalExpences(data);

                    for (String budgetType in targetBudgetTypes) {
                      double totalAmount = budgetTotalExpences
                          .where((item) => item.newBudgetType == budgetType)
                          .map((item) => item.amount)
                          .fold(
                              0.0,
                              (previousValue, amount) =>
                                  previousValue + amount);

                      totalAmounts[budgetType] = totalAmount;
                    }

                    budgetTotalExpData1 = totalAmounts.entries
                        .map((entry) => BudgetTotalExp(
                            newBudgetType: entry.key, amount: entry.value))
                        .toList();
                    contex = SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Now lets Budget you Income',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Set a Percent of your Income that you wish to save every month',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 180,
                            child: Card(
                              color: Colors.blue[100],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Total Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '₹ ${f.format(widget.totalIncome)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            //width: double.infinity,
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Amount you wish to save',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '₹ ${f.format((widget.totalIncome * _currentSliderValue) / 100)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            //width: double.infinity,
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Balance Amount to budget',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '₹ ${f.format(widget.balanceToBudget - ((widget.totalIncome * _currentSliderValue) / 100))}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              width: 7,
                            )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Saving 20% of your Income is best pratices",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 20),
                                  Slider(
                                    value: _currentSliderValue,
                                    max: 50,
                                    divisions: 100,
                                    label:
                                        _currentSliderValue.round().toString(),
                                    onChanged: (double value) {
                                      setState(() {
                                        _currentSliderValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              final savingAmount =
                                  (widget.totalIncome * _currentSliderValue) /
                                      100;
                              final balanceToBudget = widget.balanceToBudget -
                                  ((widget.totalIncome * _currentSliderValue) /
                                      100);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BudgetEdit(
                                      userMailId: widget.userMailId,
                                      userexstingExpences: budgetTotalExpData1),
                                ),
                              );

                              await FirebaseFirestore.instance
                                  .collection('users Saving Amount')
                                  .doc(widget.userMailId)
                                  .set(
                                {
                                  'saving Amount': savingAmount,
                                  'balance to budget': balanceToBudget,
                                },
                              );
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  }
                  return contex;
                },
              );
            } else if (snapshot.hasData) {
              List _userBudget = snapshot.data!['budget type'];

              budgetMaxExpences = convertListOfMapsToList2(_userBudget);

              //final num userTotalBudget = snapshot.data!['userTotalBudget'];

              contex = StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserExpencesData')
                    .doc(widget.userMailId)
                    .snapshots(),
                builder: (context, snapshot) {
                  Widget contex = const Center(
                    child: CircularProgressIndicator(),
                  );
                  if (snapshot.hasData) {
                    print('hello');
                    Map<String, double> totalAmounts = {};
                    List data = snapshot.data!['Current Expences data'];

                    List<String> targetBudgetTypes =
                        convertListOfMapsToListbudget(data);

                    budgetTotalExpences =
                        convertListOfMapsToListTotalExpences(data);

                    for (String budgetType in targetBudgetTypes) {
                      double totalAmount = budgetTotalExpences
                          .where((item) => item.newBudgetType == budgetType)
                          .map((item) => item.amount)
                          .fold(
                              0.0,
                              (previousValue, amount) =>
                                  previousValue + amount);

                      totalAmounts[budgetType] = totalAmount;
                    }

                    budgetTotalExpData = totalAmounts.entries
                        .map((entry) => BudgetTotalExp(
                            newBudgetType: entry.key, amount: entry.value))
                        .toList();
                  }
                  contex = SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Now lets Budget you Income',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Set a Percent of your Income that you wish to save every month',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 180,
                          child: Card(
                            color: Colors.blue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Total Income',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ${f.format(widget.totalIncome)}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          //width: double.infinity,
                          child: Card(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Amount you wish to save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ${f.format((widget.totalIncome * _currentSliderValue) / 100)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          //width: double.infinity,
                          child: Card(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Balance Amount to budget',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ${f.format(widget.balanceToBudget - ((widget.totalIncome * _currentSliderValue) / 100))}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            width: 7,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Saving 20% of your Income is best pratices",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 20),
                                Slider(
                                  value: _currentSliderValue,
                                  max: 50,
                                  divisions: 100,
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            final savingAmount =
                                (widget.totalIncome * _currentSliderValue) /
                                    100;
                            final balanceToBudget = widget.balanceToBudget -
                                ((widget.totalIncome * _currentSliderValue) /
                                    100);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BudgetEdit(
                                    userMailId: widget.userMailId,
                                    userexstingExpences: budgetTotalExpData),
                              ),
                            );

                            await FirebaseFirestore.instance
                                .collection('users Saving Amount')
                                .doc(widget.userMailId)
                                .set(
                              {
                                'saving Amount': savingAmount,
                                'balance to budget': balanceToBudget,
                              },
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  return contex;
                },
              );
            }
            return contex;
          },
        ),
      ),
    );
  }
}
