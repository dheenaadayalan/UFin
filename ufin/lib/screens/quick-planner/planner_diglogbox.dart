import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/plan_model.dart';

var f = NumberFormat('##,###');

class PlannerConfirmDiglogBox extends StatefulWidget {
  const PlannerConfirmDiglogBox({
    super.key,
    required this.plans,
    required this.budgetList,
    required this.savingTraget,
    required this.totalExp,
    required this.totalIncome,
    required this.planAmount,
    required this.planTitle,
    required this.selectedIndex,
    required this.budgetTotalAmount,
  });

  final List<PlanModel> plans;
  final num totalIncome;
  final num savingTraget;
  final List<Budget> budgetList;
  final num totalExp;
  final num planAmount;
  final String planTitle;
  final int selectedIndex;
  final num budgetTotalAmount;

  @override
  State<PlannerConfirmDiglogBox> createState() =>
      _PlannerConfirmDiglogBoxState();
}

class _PlannerConfirmDiglogBoxState extends State<PlannerConfirmDiglogBox> {
  @override
  Widget build(BuildContext context) {
    List<String> title = [
      'Best Possible Plan',
      '2nd Possible Plan',
      '3rd Possible Plan',
      '4th Possible Plan',
      '5th Possible Plan',
      '6th Possible Plan'
    ];

    return AlertDialog(
      actions: [
        const SizedBox(height: 22),
        SizedBox(
          //height: 400,
          child: Card(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      title[widget.selectedIndex],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Your total Income amount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${f.format(widget.totalIncome)} ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Your expense amount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${f.format(widget.totalExp)} ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Your saving amount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${f.format(widget.plans[widget.selectedIndex].saving)} ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                    if (widget.plans[widget.selectedIndex].saving <
                        widget.savingTraget)
                      Text(
                        '(This plan will reduce your savings amount)',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Your ${widget.planTitle} amount',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${f.format(widget.planAmount)} ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Your Total Budget',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          '₹ ${f.format(widget.budgetTotalAmount)} ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Card(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      child: ExpansionTile(
                        title: Text(
                          'List of your Budget',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                        ),
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Title:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiaryContainer,
                                              ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Old Budget',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiaryContainer,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'New Budget',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiaryContainer,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              for (var i = 0;
                                  i <
                                      widget.plans[widget.selectedIndex]
                                          .totalBudget.length;
                                  i++)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.plans[widget.selectedIndex]
                                            .totalBudget[i].title
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹ ${f.format(widget.plans[widget.selectedIndex].totalBudget[i].amount)} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        '₹ ${f.format(widget.budgetList[i].amount)} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save'),
            )
          ],
        )
      ],
    );
  }
}
