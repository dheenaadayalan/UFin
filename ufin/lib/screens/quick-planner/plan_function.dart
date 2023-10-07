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

  var now = DateTime.now();
  var formatterMonth = DateFormat('MM');
  var formatterMonthYear = DateFormat('d');
  var formatterMonthDateYear = DateFormat('Md');

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

  void searchPlan() {
    plans = [];
    setState(() {});
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if (planMonth == 'This Month') {
      num totalBalanceAmountLeast = 0;
      num counterLeast = 0;
      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority') {
          counterLeast = counterLeast + 1;
          totalBalanceAmountLeast =
              totalBalanceAmountLeast + widget.balanceBudgetAmount[i].amount;
        }
      }

      if (totalBalanceAmountLeast > planAmount) {
        List<Budget> newBudget = [];
        num data = 0;
        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterLeast).round()) <
                0) {
              data = (widget.balanceBudgetAmount[i].amount -
                  (planAmount / counterLeast));
            }
          }
        }

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterLeast).round()) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: (widget.budgetList[i].amount -
                          (planAmount / (counterLeast)).round()) +
                      (data / (counterLeast - 1)).round(),
                ),
              );
            }
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

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          plans.add(
            PlanModel(
              title: 'Best Possiable Plan',
              totalIncome: widget.totalIncome,
              totalExpance: widget.totalExp,
              saving: widget.savingTraget,
              totalBudget: Budget(
                title: newBudget[i].title,
                perferance: newBudget[i].perferance,
                amount: newBudget[i].amount,
              ),
            ),
          );
        }
      }

      num totalBalanceAmountLow = 0;
      num counterLow = 0;
      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority') {
          counterLow = counterLow + 1;
          totalBalanceAmountLow =
              totalBalanceAmountLow + widget.balanceBudgetAmount[i].amount;
        }
      }

      if (totalBalanceAmountLow > planAmount) {
        List<Budget> newBudget = [];
        num data = 0;
        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterLow).round()) <
                0) {
              data = (widget.balanceBudgetAmount[i].amount -
                  (planAmount / counterLow));
            }
          }
        }

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterLow).round()) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.balanceBudgetAmount[i].amount,
                ),
              );
            } else {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: (widget.budgetList[i].amount -
                          (planAmount / (counterLow)).round()) +
                      (data / (counterLow - 1)).round(),
                ),
              );
            }
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

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          plans.add(
            PlanModel(
              title: 'Secound Best Plan',
              totalIncome: widget.totalIncome,
              totalExpance: widget.totalExp,
              saving: widget.savingTraget,
              totalBudget: Budget(
                title: newBudget[i].title,
                perferance: newBudget[i].perferance,
                amount: newBudget[i].amount,
              ),
            ),
          );
        }
      }

      num totalBalanceAmountIn = 0;
      num counterIn = 0;
      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between') {
          counterIn = counterIn + 1;
          totalBalanceAmountIn =
              totalBalanceAmountIn + widget.balanceBudgetAmount[i].amount;
        }
      }

      if (totalBalanceAmountIn > planAmount) {
        List<Budget> newBudget = [];
        num data = 0;
        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterIn).round()) <
                0) {
              data = (widget.balanceBudgetAmount[i].amount -
                  (planAmount / counterIn));
            }
          }
        }

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterIn).round()) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: (widget.budgetList[i].amount -
                          (planAmount / (counterIn)).round()) +
                      (data / (counterIn - 1)).round(),
                ),
              );
            }
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

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          plans.add(
            PlanModel(
              title: '3 Best Plan',
              totalIncome: widget.totalIncome,
              totalExpance: widget.totalExp,
              saving: widget.savingTraget,
              totalBudget: Budget(
                title: newBudget[i].title,
                perferance: newBudget[i].perferance,
                amount: newBudget[i].amount,
              ),
            ),
          );
        }
      }

      num totalBalanceAmountPer = 0;
      num counterPre = 0;

      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between' ||
            widget.budgetList[i].perferance == 'Priority') {
          counterPre = counterPre + 1;
          totalBalanceAmountPer =
              totalBalanceAmountPer + widget.balanceBudgetAmount[i].amount;
        }
      }

      num counterPre1 = counterPre;
      num counterPre2 = counterPre;

      if (totalBalanceAmountPer > planAmount) {
        List<Budget> newBudget = [];
        num data = 0;

        //print(counterPre2);
        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterPre).round()) <
                0) {
              counterPre1 = counterPre - 1;
              counterPre2 = counterPre - 1;

              data = data +
                  (widget.balanceBudgetAmount[i].amount -
                      (planAmount / counterPre));
            }
          }
        }

        num data1 = 0;

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority') {
            if ((widget.budgetList[i].amount -
                            (planAmount / (counterPre)).round()) +
                        (data / (counterPre2)).round() <
                    widget.budgetTotalExpData[i].amount &&
                (widget.balanceBudgetAmount[i].amount -
                        (planAmount / counterPre).round()) >
                    0) {
              counterPre1 = counterPre1 - 1;
              counterPre2 = counterPre - 1;
              data1 = ((planAmount / (counterPre)).round() -
                      (data / (counterPre2)).round()) -
                  widget.balanceBudgetAmount[i].amount;
            }
          }
        }

        num data2 = 0;

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority') {
            if (((widget.budgetList[i].amount -
                            (planAmount / (counterPre)).round()) +
                        (data / (counterPre2 - 1))) <=
                    0 &&
                (widget.budgetList[i].amount -
                            (planAmount / (counterPre)).round()) +
                        (data / (counterPre2)).round() >
                    widget.budgetTotalExpData[i].amount &&
                (widget.balanceBudgetAmount[i].amount -
                        (planAmount / counterPre).round()) >
                    0) {
              counterPre1 = counterPre - 1;
              counterPre2 = counterPre - 1;

              print(counterPre2);
              data2 = ((planAmount / (counterPre)).round() -
                      (data / (counterPre2)).round()) -
                  widget.balanceBudgetAmount[i].amount;
            }
          }
        }

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterPre).round()) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else if ((widget.budgetList[i].amount -
                        (planAmount / (counterPre)).round()) +
                    (data / (counterPre2)).round() <
                widget.budgetTotalExpData[i].amount) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else if (((widget.budgetList[i].amount -
                        (planAmount / (counterPre)).round()) +
                    (data / (counterPre2 - 1))) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: (((widget.budgetList[i].amount -
                                  (planAmount / (counterPre)).round()) +
                              (data / (counterPre2 - 1)).round()) -
                          (data1 / (counterPre1))) +
                      (data2),
                ),
              );
            }
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

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          plans.add(
            PlanModel(
              title: '4 Best Plan',
              totalIncome: widget.totalIncome,
              totalExpance: widget.totalExp,
              saving: widget.savingTraget,
              totalBudget: Budget(
                title: newBudget[i].title,
                perferance: newBudget[i].perferance,
                amount: newBudget[i].amount,
              ),
            ),
          );
        }
      }

      num totalBalanceAmountHig = 0;
      num counterHig = 0;
      for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
        if (widget.budgetList[i].perferance == 'Least Priority' ||
            widget.budgetList[i].perferance == 'Low Priority' ||
            widget.budgetList[i].perferance == 'In between' ||
            widget.budgetList[i].perferance == 'Priority' ||
            widget.budgetList[i].perferance == 'Highest Priority') {
          counterHig = counterHig + 1;
          totalBalanceAmountHig =
              totalBalanceAmountHig + widget.balanceBudgetAmount[i].amount;
        }
      }

      if (totalBalanceAmountHig > planAmount) {
        List<Budget> newBudget = [];
        num data = 0;
        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority' ||
              widget.budgetList[i].perferance == 'Highest Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterHig).round()) <
                0) {
              data = (widget.balanceBudgetAmount[i].amount -
                  (planAmount / counterHig));
            }
          }
        }

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          if (widget.budgetList[i].perferance == 'Least Priority' ||
              widget.budgetList[i].perferance == 'Low Priority' ||
              widget.budgetList[i].perferance == 'In between' ||
              widget.budgetList[i].perferance == 'Priority' ||
              widget.budgetList[i].perferance == 'Highest Priority') {
            if ((widget.balanceBudgetAmount[i].amount -
                    (planAmount / counterHig).round()) <
                0) {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: widget.budgetTotalExpData[i].amount,
                ),
              );
            } else {
              newBudget.add(
                Budget(
                  title: widget.budgetList[i].title,
                  perferance: widget.budgetList[i].perferance,
                  amount: (widget.budgetList[i].amount -
                          (planAmount / (counterHig)).round()) +
                      (data / (counterHig - 1)).round(),
                ),
              );
            }
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

        for (var i = 0; i < widget.balanceBudgetAmount.length; i++) {
          plans.add(
            PlanModel(
              title: '5 Possiable Plan',
              totalIncome: widget.totalIncome,
              totalExpance: widget.totalExp,
              saving: widget.savingTraget,
              totalBudget: Budget(
                title: newBudget[i].title,
                perferance: newBudget[i].perferance,
                amount: newBudget[i].amount,
              ),
            ),
          );
        }
      }
    }
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
                                planMonth = 'Evey Month';
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
                    if (_selectedMonth[0] == true)
                      Row(
                        children: [
                          const Text(
                            'At what Date to have pay \nthis commitment',
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
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              if (plans.isEmpty) {
                return const Center(child: Text('Nothing here'));
              } else if (plans.isNotEmpty) {
                return Column(
                  children: [
                    Text(plans[index].title),
                    Text(plans[index].totalBudget.title),
                    Text(plans[index].totalBudget.amount.toString())
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        )
      ],
    );
  }
}
