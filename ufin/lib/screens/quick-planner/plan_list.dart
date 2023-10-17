import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/plan_model.dart';

import 'package:ufin/screens/quick-planner/planner_diglogbox.dart';

var f = NumberFormat('##,###');

class PlanListView extends StatefulWidget {
  const PlanListView({
    super.key,
    required this.plans,
    required this.budgetList,
    required this.savingTraget,
    required this.totalExp,
    required this.totalIncome,
    required this.planAmount,
    required this.planTitle,
    required this.commitmentList,
    required this.selectedDate,
    required this.planMonth,
    required this.planCommit,
  });

  final List<PlanModel> plans;
  final num totalIncome;
  final num savingTraget;
  final List<Budget> budgetList;
  final num totalExp;
  final num planAmount;
  final String planTitle;
  final List<Commitment> commitmentList;
  final DateTime selectedDate;
  final String planMonth;
  final String planCommit;

  @override
  State<PlanListView> createState() => _PlanListViewState();
}

class _PlanListViewState extends State<PlanListView> {
  PlanModel? selectedPlan;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.planMonth);
    return Column(
      children: [
        if (widget.plans.isEmpty)
          Container(
            margin: const EdgeInsets.all(15),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to UFin Planner',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Currently under beta mode',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        if (widget.plans.isNotEmpty)
          SizedBox(
            height: 360,
            child: CarouselSlider.builder(
              itemCount: widget.plans.length,
              itemBuilder:
                  (BuildContext context, int index, int pageViewIndex) {
                List<String> title = [
                  'Best Possible Plan',
                  '2nd Possible Plan',
                  '3rd Possible Plan',
                  '4th Possible Plan',
                  '5th Possible Plan',
                  '6th Possible Plan'
                ];
                num userPlantotalBudget = 0;
                for (var i = 0;
                    i < widget.plans[index].totalBudget.length;
                    i++) {
                  userPlantotalBudget = userPlantotalBudget +
                      widget.plans[index].totalBudget[i].amount;
                }

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
                        selectedPlan = PlanModel(
                          title: widget.plans[index].title,
                          totalIncome: widget.plans[index].totalIncome,
                          totalExpance: widget.plans[index].totalExpance,
                          saving: widget.plans[index].saving,
                          totalBudget: widget.plans[index].totalBudget,
                        );
                      },
                    );
                  },
                  title: SizedBox(
                    height: 360,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                      child: Card(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  title[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Text(
                                      'Your total Income',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${f.format(widget.totalIncome)} ',
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
                                      'Your total expense',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${f.format(widget.totalExp)} ',
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
                                      'Your saving amount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${f.format(widget.plans[index].saving)} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),
                                if (widget.plans[index].saving <
                                    widget.savingTraget)
                                  Text(
                                    '(This plan will reduce your savings amount)',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      'Your ${widget.planTitle} amount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${f.format(widget.planAmount)} ',
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
                                      'Your Total Budget',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${f.format(userPlantotalBudget)} ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Card(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  child: ExpansionTile(
                                    title: Text(
                                      'List of your Budget',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                    ),
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 5, 15, 0),
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
                                                            color: Theme.of(
                                                                    context)
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
                                                            color: Theme.of(
                                                                    context)
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
                                                            color: Theme.of(
                                                                    context)
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
                                                  widget.plans[index]
                                                      .totalBudget.length;
                                              i++)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    widget.plans[index]
                                                        .totalBudget[i].title
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '₹ ${f.format(widget.plans[index].totalBudget[i].amount)} ',
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
                  ),
                );
              },
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false, //change this later to true
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true, //change this later to true
                enlargeFactor: 0.3,
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (widget.plans.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              num userPlantotalBudget = 0;
              var index = selectedIndex;
              for (var i = 0; i < widget.plans[index].totalBudget.length; i++) {
                userPlantotalBudget = userPlantotalBudget +
                    widget.plans[index].totalBudget[i].amount;
              }

              showDialog(
                context: context,
                builder: (context) => PlannerConfirmDiglogBox(
                  budgetList: widget.budgetList,
                  planAmount: widget.planAmount,
                  planTitle: widget.planTitle,
                  plans: widget.plans,
                  savingTraget: widget.savingTraget,
                  totalExp: widget.totalExp,
                  totalIncome: widget.totalIncome,
                  selectedIndex: selectedIndex,
                  budgetTotalAmount: userPlantotalBudget,
                  commitmentList: widget.commitmentList,
                  selectedDate: widget.selectedDate,
                  planMonth: widget.planMonth,
                  planCommit: widget.planCommit,
                ),
              );
            },
            child: const Text('Continue'),
          )
      ],
    );
  }
}
