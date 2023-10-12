import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/screens/planner-screen/budget/barchart/color_extension.dart';
import 'package:ufin/screens/planner-screen/budget/budget_builder.dart';

var f = NumberFormat('##,###');

class BudgetBarChart extends StatefulWidget {
  const BudgetBarChart({super.key});

  @override
  State<BudgetBarChart> createState() => _BudgetBarChartState();
}

class _BudgetBarChartState extends State<BudgetBarChart> {
  List<Budget> userBudget = [];
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  List<BudgetTotalExp> budgetTotalExpences = [];
  List<String> budgetType = [];
  List budgetMaxExpences = [];
  List<BudgetTotalExp> budgetTotalExpData = [];
  List<BudgetTotalExp> budgetTotalExpData1 = [];
  var now = DateTime.now();
  var formatter = DateFormat('MM');
  bool newBudget = false;
  var newBudgetMonth = 0;

  @override
  void initState() {
    initialize();
    initialize1();
    initialize2();
    super.initState();
  }

  void initialize() async {
    await FirebaseFirestore.instance
        .collection('UserExpencesData')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      List commitMap = doc['Current Expences data'];

      budgetTotalExpences = convertListOfMapsToList(commitMap);
      budgetType = convertListOfMapsToList1(commitMap);
    });
  }

  void initialize1() async {
    await FirebaseFirestore.instance
        .collection('usersBudget')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) {
      List commitMap = doc['budget type'];

      budgetMaxExpences = convertListOfMapsToList2(commitMap);
    });
  }

  List<BudgetTotalExp> convertListOfMapsToList(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return BudgetTotalExp(
        newBudgetType: listOfMaps[index]['Budget'],
        amount: listOfMaps[index]['Amount'],
      );
    });
  }

  List<String> convertListOfMapsToList1(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return listOfMaps[index]['Budget'];
    });
  }

  List convertListOfMapsToList2(listOfMaps) {
    return List.generate(listOfMaps.length, (index) {
      return listOfMaps[index]['amount'];
    });
  }

  void initialize2() async {
    await FirebaseFirestore.instance
        .collection('budgetRefactor')
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot doc) async {
      setState(() {
        newBudget = doc['bool'];
        newBudgetMonth = int.parse(formatter.format(doc['Month'].toDate()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

    List convertListOfMapsToList2(listOfMaps) {
      return List.generate(listOfMaps.length, (index) {
        return listOfMaps[index]['amount'];
      });
    }

    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 400,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('usersBudget')
                  .doc(userEmail)
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

                  final num userTotalBudget = snapshot.data!['userTotalBudget'];
                  contex = Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (newBudget == false &&
                                  newBudgetMonth !=
                                      int.parse(formatter.format(now)))
                                Text(
                                  'Total Budget ${f.format(snapshot.data!['userTotalBudget'])}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                ),
                              if (newBudget == true &&
                                  newBudgetMonth ==
                                      int.parse(formatter.format(now)))
                                Text(
                                  'New Budget ', //${f.format(snapshot.data!['userTotalBudget'])}
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetBuilder(
                                        userMailId: userEmail.toString(),
                                        userTotalBudget: userTotalBudget,
                                        userBudgetExp: budgetTotalExpData1,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 2, 46, 69)),
                                  padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(10),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text('Budget Planner'),
                                    Icon(Icons.arrow_right_alt),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('UserExpencesData')
                                  .doc(userEmail)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                Widget contex = const Center(
                                  child: CircularProgressIndicator(),
                                );
                                if (snapshot.hasData) {
                                  Map<String, double> totalAmounts = {};
                                  List data =
                                      snapshot.data!['Current Expences data'];

                                  List<String> targetBudgetTypes =
                                      convertListOfMapsToListbudget(data);

                                  budgetTotalExpences =
                                      convertListOfMapsToListTotalExpences(
                                          data);

                                  for (String budgetType in targetBudgetTypes) {
                                    double totalAmount = budgetTotalExpences
                                        .where((item) =>
                                            item.newBudgetType == budgetType)
                                        .map((item) => item.amount)
                                        .fold(
                                            0.0,
                                            (previousValue, amount) =>
                                                previousValue + amount);

                                    totalAmounts[budgetType] = totalAmount;
                                  }

                                  budgetTotalExpData1 = totalAmounts.entries
                                      .map((entry) => BudgetTotalExp(
                                          newBudgetType: entry.key,
                                          amount: entry.value))
                                      .toList();

                                  List maxData = [1, 2, 3, 4, 5];
                                  var largestGeekValue = maxData[0];

                                  for (var i = 0;
                                      i < budgetMaxExpences.length;
                                      i++) {
                                    if (budgetMaxExpences[i] >
                                        largestGeekValue) {
                                      largestGeekValue = budgetMaxExpences[i];
                                    }
                                  }

                                  double www = 350;

                                  if (_userBudget.length >= 6 &&
                                      _userBudget.length <= 8) {
                                    www = 400;
                                  } else if (_userBudget.length >= 9 &&
                                      _userBudget.length <= 11) {
                                    www = 450;
                                  } else if (_userBudget.length >= 12 &&
                                      _userBudget.length <= 14) {
                                    www = 500;
                                  }

                                  contex = SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: www,
                                      child: BarChart(
                                        BarChartData(
                                          barTouchData: barTouchData,
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              axisNameSize: 30,
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                interval: 1,
                                                getTitlesWidget: (value, meta) {
                                                  var date = value.toInt() >=
                                                          userBudget.length
                                                      ? _userBudget[value
                                                          .toInt()]['title']
                                                      : "hello";
                                                  return SideTitleWidget(
                                                    axisSide: meta.axisSide,
                                                    child: Text(date),
                                                  );
                                                },
                                              ),
                                            ),
                                            leftTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                          ),
                                          borderData: borderData,
                                          barGroups: [
                                            if (budgetTotalExpData1.isEmpty)
                                              BarChartGroupData(
                                                x: 0,
                                              )
                                            else
                                              for (int i = 0;
                                                  i < _userBudget.length;
                                                  i++)
                                                BarChartGroupData(
                                                  x: i,
                                                  barsSpace: 15,
                                                  barRods: [
                                                    BarChartRodData(
                                                        toY: _userBudget[i]
                                                                ['amount'] +
                                                            0.0,
                                                        width: 10,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer),
                                                    BarChartRodData(
                                                        toY:
                                                            budgetTotalExpData1[
                                                                        i]
                                                                    .amount
                                                                as double)
                                                  ],
                                                  showingTooltipIndicators: [
                                                    0,
                                                    1
                                                  ],
                                                ),
                                          ],
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          gridData:
                                              const FlGridData(show: false),
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY: largestGeekValue + 1300.0,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return contex;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List _userBudget = snapshot.data!['budget type'];

                  budgetMaxExpences = convertListOfMapsToList2(_userBudget);

                  final num userTotalBudget = snapshot.data!['userTotalBudget'];
                  contex = Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Budget ${f.format(snapshot.data!['userTotalBudget'])}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetBuilder(
                                        userMailId: userEmail.toString(),
                                        userTotalBudget: userTotalBudget,
                                        userBudgetExp: budgetTotalExpData,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(255, 2, 46, 69)),
                                  padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(10),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text('Budget Planner'),
                                    Icon(Icons.arrow_right_alt),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('UserExpencesData')
                                  .doc(userEmail)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                Widget contex = const Center(
                                  child: CircularProgressIndicator(),
                                );
                                if (snapshot.hasData) {
                                  Map<String, double> totalAmounts = {};
                                  List data =
                                      snapshot.data!['Current Expences data'];

                                  List<String> targetBudgetTypes =
                                      convertListOfMapsToListbudget(data);

                                  budgetTotalExpences =
                                      convertListOfMapsToListTotalExpences(
                                          data);

                                  for (String budgetType in targetBudgetTypes) {
                                    double totalAmount = budgetTotalExpences
                                        .where((item) =>
                                            item.newBudgetType == budgetType)
                                        .map((item) => item.amount)
                                        .fold(
                                            0.0,
                                            (previousValue, amount) =>
                                                previousValue + amount);

                                    totalAmounts[budgetType] = totalAmount;
                                  }

                                  budgetTotalExpData = totalAmounts.entries
                                      .map((entry) => BudgetTotalExp(
                                          newBudgetType: entry.key,
                                          amount: entry.value))
                                      .toList();

                                  List maxData = [1, 2, 3, 4, 5];
                                  var largestGeekValue = maxData[0];

                                  for (var i = 0;
                                      i < budgetMaxExpences.length;
                                      i++) {
                                    if (budgetMaxExpences[i] >
                                        largestGeekValue) {
                                      largestGeekValue = budgetMaxExpences[i];
                                    }
                                  }

                                  double www = 350;

                                  if (_userBudget.length >= 6 &&
                                      _userBudget.length <= 8) {
                                    www = 400;
                                  } else if (_userBudget.length >= 9 &&
                                      _userBudget.length <= 11) {
                                    www = 450;
                                  } else if (_userBudget.length >= 12 &&
                                      _userBudget.length <= 14) {
                                    www = 500;
                                  }

                                  contex = SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: www,
                                      child: BarChart(
                                        BarChartData(
                                          barTouchData: barTouchData,
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              axisNameSize: 30,
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                interval: 1,
                                                getTitlesWidget: (value, meta) {
                                                  var date = value.toInt() >=
                                                          userBudget.length
                                                      ? _userBudget[value
                                                          .toInt()]['title']
                                                      : "hello";
                                                  return SideTitleWidget(
                                                    axisSide: meta.axisSide,
                                                    child: Text(date),
                                                  );
                                                },
                                              ),
                                            ),
                                            leftTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles:
                                                  SideTitles(showTitles: false),
                                            ),
                                          ),
                                          borderData: borderData,
                                          barGroups: [
                                            if (budgetTotalExpData.isEmpty)
                                              BarChartGroupData(
                                                x: 0,
                                              )
                                            else
                                              for (int i = 0;
                                                  i < _userBudget.length;
                                                  i++)
                                                BarChartGroupData(
                                                  x: i,
                                                  barsSpace: 15,
                                                  barRods: [
                                                    BarChartRodData(
                                                        toY: _userBudget[i]
                                                                ['amount'] +
                                                            0.0,
                                                        width: 10,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer),
                                                    BarChartRodData(
                                                        toY: budgetTotalExpData[
                                                                i]
                                                            .amount as double)
                                                  ],
                                                  showingTooltipIndicators: [
                                                    0,
                                                    1
                                                  ],
                                                ),
                                          ],
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          gridData:
                                              const FlGridData(show: false),
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY: largestGeekValue + 1300.0,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return contex;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return contex;
              },
            ),
          ),
        ],
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppColors.contentColorCyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(userBudget[value.toInt()].title);
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );
  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColors.contentColorBlue, //.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
