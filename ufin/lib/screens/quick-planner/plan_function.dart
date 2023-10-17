import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ufin/models/budget_model.dart';
import 'package:ufin/models/commitmet_model.dart';
import 'package:ufin/models/expences_modes.dart';
import 'package:ufin/models/plan_model.dart';

var f = NumberFormat('##,###');

const List<Widget> month = [
  Text('This Month'),
  Text('Evey Month'),
];

const List<Widget> commitOrBudget = [
  Text('Commiment'),
  Text('  Budget '),
];

class PlanSearch extends StatefulWidget {
  const PlanSearch({
    super.key,
    required this.budgetList,
    required this.commitmentList,
    required this.totalIncome,
    required this.savingTraget,
    required this.budgetTotalExpences,
    required this.budgetTotalExpData,
    required this.totalExp,
    required this.blanceAmount,
    required this.balanceBudgetAmount,
    required this.userMailId,
    required this.onPickBudget,
    required this.onPickPlanAmount,
    required this.onPickPlanName,
    required this.onPickDateTime,
    required this.onPickPlanMonth,
    required this.onPickPlanCommit,
  });

  final List<Budget> budgetList;
  final List<Commitment> commitmentList;
  final num totalIncome;
  final num savingTraget;
  final List<BudgetTotalExp> budgetTotalExpences;
  final List<BudgetTotalExp> budgetTotalExpData;
  final num totalExp;
  final num blanceAmount;
  final List<BudgetTotalExp> balanceBudgetAmount;
  final String userMailId;
  final void Function(List<PlanModel> pickedBudget) onPickBudget;
  final void Function(String pickedPlanName) onPickPlanName;
  final void Function(num pickedPlanAmount) onPickPlanAmount;
  final void Function(DateTime pickedDateTime) onPickDateTime;
  final void Function(String pickedPlanMonth) onPickPlanMonth;
  final void Function(String pickedPlanCommit) onPickPlanCommit;

  @override
  State<PlanSearch> createState() => _PlanSearchState();
}

class _PlanSearchState extends State<PlanSearch> {
  final _form = GlobalKey<FormState>();

  final List<bool> _selectedMonth = <bool>[true, false];
  final List<bool> _selectedCommit = <bool>[true, false];
  bool showBudgetOrCommitment = false;
  DateTime selectedDate = DateTime.now();
  num planAmount = 0;
  String planTitle = '';
  String planMonth = 'This Month';
  String planCommit = 'Commiment';

  List<PlanModel> plans = [];
  List<Budget> budgetNew = [];

  var now = DateTime.now();
  var formatterMonth = DateFormat('MM');
  var formatterMonthYear = DateFormat('d');
  var formatterMonthDateYear = DateFormat('Md');

  bool beta = false;

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

  void planFunction() {
    num totalBalanceAmountLeast = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority') {
        totalBalanceAmountLeast =
            totalBalanceAmountLeast + widget.balanceBudgetAmount[i].amount;
      }
    }

    if (totalBalanceAmountLeast > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          (widget.balanceBudgetAmount[i].amount /
                              totalBalanceAmountLeast)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: 'Best Possiable Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: widget.savingTraget,
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }

    num totalBalanceAmountLow = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority' ||
          widget.budgetList[i].perferance == 'Low Priority') {
        totalBalanceAmountLow =
            totalBalanceAmountLow + widget.balanceBudgetAmount[i].amount;
      }
    }

    if (totalBalanceAmountLow > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          (widget.balanceBudgetAmount[i].amount /
                              totalBalanceAmountLow)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: 'Secound Best Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: widget.savingTraget,
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }

    num totalBalanceAmountIn = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority' ||
          widget.budgetList[i].perferance == 'Low Priority' ||
          widget.budgetList[i].perferance == 'In between') {
        totalBalanceAmountIn =
            totalBalanceAmountIn + widget.balanceBudgetAmount[i].amount;
      }
    }

    if (totalBalanceAmountIn > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          (widget.balanceBudgetAmount[i].amount /
                              totalBalanceAmountIn)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: '3 Best Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: widget.savingTraget,
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }

    num totalBalanceAmountPer = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority' ||
          widget.budgetList[i].perferance == 'Low Priority' ||
          widget.budgetList[i].perferance == 'In between' ||
          widget.budgetList[i].perferance == 'Priority') {
        totalBalanceAmountPer =
            totalBalanceAmountPer + widget.balanceBudgetAmount[i].amount;
      }
    }

    if (totalBalanceAmountPer > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between' ||
            widget.budgetList[i].perferance == 'Priority') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          (widget.balanceBudgetAmount[i].amount /
                              totalBalanceAmountPer)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: '4 Best Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: widget.savingTraget,
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }

    num totalBalanceAmountHig = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority' ||
          widget.budgetList[i].perferance == 'Low Priority' ||
          widget.budgetList[i].perferance == 'In between' ||
          widget.budgetList[i].perferance == 'Priority' ||
          widget.budgetList[i].perferance == 'Highest Priority') {
        totalBalanceAmountHig =
            totalBalanceAmountHig + widget.balanceBudgetAmount[i].amount;
      }
    }

    if (totalBalanceAmountHig > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between' ||
            widget.budgetList[i].perferance == 'Priority' ||
            widget.budgetList[i].perferance == 'Highest Priority') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          (widget.balanceBudgetAmount[i].amount /
                              totalBalanceAmountHig)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: '5 Possiable Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: widget.savingTraget,
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }
    num totalBalanceAmountSav = 0;

    for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
      if (widget.budgetList[i].perferance == 'Least Priority' ||
          widget.budgetList[i].perferance == 'Low Priority' ||
          widget.budgetList[i].perferance == 'In between' ||
          widget.budgetList[i].perferance == 'Priority' ||
          widget.budgetList[i].perferance == 'Highest Priority') {
        totalBalanceAmountSav =
            totalBalanceAmountSav + widget.balanceBudgetAmount[i].amount;
      }
    }
    totalBalanceAmountSav = totalBalanceAmountSav + widget.savingTraget;

    if (totalBalanceAmountSav > planAmount) {
      List<Budget> newBudget = [];

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between' ||
            widget.budgetList[i].perferance == 'Priority' ||
            widget.budgetList[i].perferance == 'Highest Priority') {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount -
                  ((planAmount *
                          ((widget.balanceBudgetAmount[i].amount) /
                              totalBalanceAmountSav)))
                      .round(),
            ),
          );
        } else {
          newBudget.add(
            Budget(
              title: widget.budgetList[i].title,
              perferance: widget.budgetList[i].perferance,
              amount: widget.budgetList[i].amount,
            ),
          );
        }
      }

      plans.add(
        PlanModel(
          title: '6 Possiable Plan',
          totalIncome: widget.totalIncome,
          totalExpance: widget.totalExp,
          saving: (widget.savingTraget) -
              ((planAmount * ((widget.savingTraget) / totalBalanceAmountSav)))
                  .round(),
          totalBudget: List<Budget>.from(newBudget),
        ),
      );
    }
    setState(() {});
  }

  void searchPlan() async {
    plans = [];

    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if (planMonth == 'Every Month' && planCommit == 'Commiment') {
      planFunction();
    }

    if (planMonth == 'This Month') {
      planFunction();
    }

    if (planMonth == 'Every Month' && planCommit == '  Budget ') {
      planFunction();
    }

    widget.onPickPlanAmount(planAmount);
    widget.onPickBudget(plans);
    widget.onPickPlanName(planTitle);
    widget.onPickDateTime(selectedDate);
    widget.onPickPlanMonth(planMonth);
    widget.onPickPlanCommit(planCommit);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Card(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Do you what this plan only for?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selectedMonth.length; i++) {
                                _selectedMonth[i] = i == index;
                              }
                              if (index == 1) {
                                planMonth = 'Every Month';
                              }
                              if (index == 0) {
                                planMonth = 'This Month';
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.blue[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.blue[200],
                          color: Colors.white,
                          borderColor: Colors.white,
                          constraints: const BoxConstraints(
                            minHeight: 38.0,
                            minWidth: 75.0,
                          ),
                          isSelected: _selectedMonth,
                          children: month,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_selectedMonth[1] == true)
                      Row(
                        children: [
                          const Text(
                            'Is it fixed like commitment or \nflixable like budget?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0;
                                    i < _selectedCommit.length;
                                    i++) {
                                  _selectedCommit[i] = i == index;
                                  if (index == 1) {
                                    planCommit = '  Budget ';
                                  }
                                  if (index == 0) {
                                    planCommit = 'Commiment';
                                  }
                                }
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedBorderColor: Colors.blue[700],
                            selectedColor: Colors.white,
                            fillColor: Colors.blue[200],
                            color: Colors.white,
                            borderColor: Colors.white,
                            constraints: const BoxConstraints(
                              minHeight: 38.0,
                              minWidth: 75.0,
                            ),
                            isSelected: _selectedCommit,
                            children: commitOrBudget,
                          ),
                        ],
                      ),
                    if (_selectedMonth[0] == true || _selectedCommit[0] == true)
                      Row(
                        children: [
                          const Text(
                            'At what date you have to use \nthis amount ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            ),
                            child: Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Give it Name ',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      onSaved: (newValue) {
                        planTitle = newValue!;
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            planTitle = '';
                          });
                        } else {
                          setState(() {
                            planTitle = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter a valid amount';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            onSaved: (newValue) {
                              planAmount = int.parse(newValue!);
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  planAmount = 0;
                                });
                              } else {
                                setState(() {
                                  planAmount = int.parse(value);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => searchPlan(),
                          icon: const Icon(Icons.search),
                          label: const Text('Plan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (beta == true)
          Container(
            margin: const EdgeInsets.all(15),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick planner for "Every Month" will be available soon!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Its currently beening tested internaly',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
