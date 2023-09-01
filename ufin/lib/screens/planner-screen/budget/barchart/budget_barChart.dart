import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/models/budget_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
            if (snapshot.hasData) {
              List _userBudget = snapshot.data!['budget type'];
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
                                      userTotalBudget: userTotalBudget),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey),
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
                                        ? _userBudget[value.toInt()]['title']
                                        : "hello";
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(date),
                                    );
                                    //return Text(_userBudget[value.toInt()]['title']);
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
                            ),
                            borderData: borderData,
                            barGroups: [
                              for (int i = 0; i < _userBudget.length; i++)
                                BarChartGroupData(
                                  x: i,
                                  barsSpace: 15,
                                  barRods: [
                                    BarChartRodData(
                                        toY: _userBudget[i]['amount'] + 0.0,
                                        width: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer),
                                    BarChartRodData(toY: 2500)
                                  ],
                                  showingTooltipIndicators: [0, 1],
                                ),
                            ], //  barGroups, // userb,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 5500,
                          ),
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
