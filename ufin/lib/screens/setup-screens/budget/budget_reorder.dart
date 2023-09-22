import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ufin/screens/home_tabs.dart';
import 'package:ufin/models/budget_model.dart';

class BudgetReorder extends StatefulWidget {
  const BudgetReorder(
      {super.key, required this.userMailId, required this.budget});

  final String userMailId;
  final List<Budget> budget;

  @override
  State<BudgetReorder> createState() => _BudgetReorderState();
}

class _BudgetReorderState extends State<BudgetReorder> {
  void save() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return const HomeTabsScreen();
        },
      ),
      (Route route) => false,
    );

    List<Map<String, Object>> data = [
      for (var index in widget.budget)
        {
          'title': index.title,
          'amount': index.amount,
          'perferance type': index.perferance,
        }
    ];

    await FirebaseFirestore.instance
        .collection('usersBudgetPerority')
        .doc(widget.userMailId)
        .set(
      {
        'budget type': data,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Scaffold(
      appBar: AppBar(
        title: const Text('UFin'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: Text(
              'Reorder your budget based on your priority',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            child: Text(
              'Number 1 being, the budget that is most importance to you.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            child: Text(
              'Long-Press and reoder your budget.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: 400,
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: <Widget>[
                for (int index = 0; index < widget.budget.length; index += 1)
                  ListTile(
                    key: Key('$index'),
                    tileColor: index.isOdd ? oddItemColor : evenItemColor,
                    title: Row(
                      children: [
                        Text("${index + 1}"),
                        const SizedBox(width: 10),
                        Text(widget.budget[index].title),
                        const SizedBox(width: 30),
                        Text('₹ ${widget.budget[index].amount}'),
                        const SizedBox(width: 15),
                        Text(widget.budget[index].perferance),
                        const Spacer(),
                        const Icon(Icons.drag_handle)
                      ],
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = widget.budget.removeAt(oldIndex);
                  widget.budget.insert(newIndex, item);
                });
                for (int index = 0; index < widget.budget.length; index += 1) {
                  print(widget.budget[index].title);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: save, child: const Text('Save'))
        ],
      ),
    );
  }
}
